import crypto from 'crypto';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export class LogoutUseCase {
  constructor(
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(userId: string, refreshToken?: string, ipAddress: string = '127.0.0.1', userAgent: string = 'Unknown') {
    if (refreshToken) {
      const tokenHash = crypto.createHash('sha256').update(refreshToken).digest('hex');
      const tokenDoc = await this.refreshTokenRepo.findByHash(tokenHash);
      if (tokenDoc) {
        await this.sessionRepo.revokeById(tokenDoc.sessionId, userId);
        await this.refreshTokenRepo.revokeAllForSession(tokenDoc.sessionId);
      }
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'logout',
      ipAddress,
      userAgent,
    });

    return { success: true, message: 'Logged out successfully' };
  }

  public async executeLogoutAll(userId: string, ipAddress: string = '127.0.0.1', userAgent: string = 'Unknown') {
    await this.sessionRepo.revokeAllUserSessions(userId);
    await this.refreshTokenRepo.revokeAllForUser(userId);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'logout_all',
      ipAddress,
      userAgent,
    });

    return { success: true, message: 'Logged out from all devices successfully' };
  }
}
