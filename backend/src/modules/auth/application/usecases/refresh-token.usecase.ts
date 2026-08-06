import crypto from 'crypto';
import jwt from 'jsonwebtoken';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export interface RefreshTokenDto {
  refreshToken: string;
  ipAddress: string;
  userAgent: string;
}

export class RefreshTokenUseCase {
  constructor(
    private userRepo: UserRepository,
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
    private jwtSecret: string,
  ) {}

  public async execute(dto: RefreshTokenDto) {
    const tokenHash = crypto.createHash('sha256').update(dto.refreshToken).digest('hex');
    const existingToken = await this.refreshTokenRepo.findByHash(tokenHash);

    if (!existingToken) {
      throw new Error('Invalid refresh token');
    }

    // Reuse Detection Security Check
    if (existingToken.isUsed || existingToken.isRevoked) {
      // Token reuse detected! Revoke all tokens in this family to neutralize attack.
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

    // Check expiration
    if (new Date() > new Date(existingToken.expiresAt)) {
      throw new Error('Refresh token expired');
    }

    const user = await this.userRepo.findById(existingToken.userId);
    if (!user || user.status === 'deactivated' || user.status === 'deleted') {
      throw new Error('User inactive or deleted');
    }

    // Mark current token as used
    await this.refreshTokenRepo.markAsUsed(existingToken._id);

    // Generate NEW Access & Refresh Token (Token Rotation)
    const newAccessToken = jwt.sign(
      { sub: user._id, role: user.role, email: user.email, phone: user.phone },
      this.jwtSecret,
      { expiresIn: '15m' },
    );

    const newRefreshTokenRaw = crypto.randomBytes(40).toString('hex');
    const newRefreshTokenHash = crypto
      .createHash('sha256')
      .update(newRefreshTokenRaw)
      .digest('hex');

    // Create New Refresh Token under SAME Family ID
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

    // Touch Session
    await this.sessionRepo.touchSession(existingToken.sessionId);

    // Log Action
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
      expiresInSeconds: 15 * 60,
    };
  }
}
