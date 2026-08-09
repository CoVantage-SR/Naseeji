import crypto from 'crypto';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';
import { JwtService } from '../../security/services/jwt.service.js';

export interface RefreshTokenDto {
  refreshToken: string;
  ipAddress: string;
  userAgent: string;
}

/** Statuses that should block token rotation */
const BLOCKED_STATUSES = ['deactivated', 'deleted', 'blocked', 'suspended', 'rejected'] as const;

export class RefreshTokenUseCase {
  private readonly jwtService: JwtService;

  constructor(
    private userRepo: UserRepository,
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
    // jwtSecret kept for backward compatibility — JwtService reads from env internally
    _jwtSecret?: string,
  ) {
    this.jwtService = new JwtService();
  }

  public async execute(dto: RefreshTokenDto): Promise<Record<string, unknown>> {
    const tokenHash = crypto.createHash('sha256').update(dto.refreshToken).digest('hex');
    const existingToken = await this.refreshTokenRepo.findByHash(tokenHash);

    if (!existingToken) {
      throw new Error('Invalid refresh token');
    }

    // Reuse Detection Security Check — revoke entire family on stolen token replay
    if (existingToken.isUsed || existingToken.isRevoked) {
      await this.refreshTokenRepo.revokeFamily(existingToken.familyId);
      await this.sessionRepo.revokeById(existingToken.sessionId, existingToken.userId);

      await this.securityLogRepo.logAction({
        _id: crypto.randomUUID(),
        userId: existingToken.userId,
        action: 'token_reuse_detected',
        ipAddress: dto.ipAddress,
        userAgent: dto.userAgent,
        metadata: {
          familyId: existingToken.familyId,
          warning: 'Revoked all session tokens due to reuse attempt',
        },
      });

      throw new Error('Refresh token security violation. All sessions have been revoked.');
    }

    // Check token expiration
    if (new Date() > new Date(existingToken.expiresAt)) {
      throw new Error('Refresh token expired');
    }

    // Verify the parent session is still active (not manually revoked)
    const session = await this.sessionRepo.findById(existingToken.sessionId);
    if (!session || session.isRevoked) {
      throw new Error('Session has been revoked. Please log in again.');
    }

    const user = await this.userRepo.findById(existingToken.userId);
    if (!user) {
      throw new Error('User not found');
    }

    if (BLOCKED_STATUSES.includes(user.status as (typeof BLOCKED_STATUSES)[number])) {
      await this.refreshTokenRepo.revokeFamily(existingToken.familyId);
      await this.sessionRepo.revokeById(existingToken.sessionId, existingToken.userId);
      throw new Error(`Account access denied. Status: ${user.status}`);
    }

    // Mark current token as used (prevents replay)
    await this.refreshTokenRepo.markAsUsed(existingToken._id);

    // Issue new access + refresh tokens (token rotation)
    const {
      accessToken: newAccessToken,
      refreshToken: newRefreshTokenRaw,
      accessTokenExpiresIn,
    } = this.jwtService.issueTokens(user._id, existingToken.sessionId, user.role, [user.role]);

    const newRefreshTokenHash = crypto
      .createHash('sha256')
      .update(newRefreshTokenRaw)
      .digest('hex');

    // Create new refresh token under the SAME family (rotation chain)
    await this.refreshTokenRepo.create({
      _id: crypto.randomUUID(),
      userId: user._id,
      sessionId: existingToken.sessionId,
      tokenHash: newRefreshTokenHash,
      familyId: existingToken.familyId,
      isUsed: false,
      isRevoked: false,
      expiresAt: existingToken.expiresAt,
    });

    // Update session hash & lastActiveAt
    await this.sessionRepo.touchSession(existingToken.sessionId);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: user._id,
      action: 'token_refreshed',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
    });

    return {
      accessToken: newAccessToken,
      refreshToken: newRefreshTokenRaw,
      tokenType: 'Bearer',
      expiresInSeconds: accessTokenExpiresIn,
    };
  }
}
