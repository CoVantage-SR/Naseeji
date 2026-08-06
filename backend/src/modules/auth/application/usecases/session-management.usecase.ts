import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export class SessionManagementUseCase {
  constructor(
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async getActiveSessions(userId: string) {
    const sessions = await this.sessionRepo.findActiveByUserId(userId);
    return sessions.map((s) => ({
      id: s._id,
      deviceId: s.deviceId,
      deviceInfo: s.deviceInfo,
      ipAddress: s.ipAddress,
      country: s.country,
      lastActiveAt: s.lastActiveAt,
      createdAt: s.createdAt,
    }));
  }

  public async revokeSession(userId: string, sessionId: string, ip: string, userAgent: string) {
    const revoked = await this.sessionRepo.revokeById(sessionId, userId);
    if (revoked) {
      await this.refreshTokenRepo.revokeAllForSession(sessionId);
      await this.securityLogRepo.logAction({
        _id: crypto.randomUUID(),
        userId,
        action: 'logout',
        ipAddress: ip,
        userAgent,
        metadata: { revokedSessionId: sessionId },
      });
    }
    return { success: revoked, message: revoked ? 'Device session revoked' : 'Session not found' };
  }

  public async revokeAllSessions(userId: string, ip: string, userAgent: string) {
    await this.sessionRepo.revokeAllUserSessions(userId);
    await this.refreshTokenRepo.revokeAllForUser(userId);
    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'logout_all',
      ipAddress: ip,
      userAgent,
    });
    return { success: true, message: 'All active sessions revoked' };
  }
}
