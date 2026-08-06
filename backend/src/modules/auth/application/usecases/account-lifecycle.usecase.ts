import crypto from 'crypto';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export class AccountLifecycleUseCase {
  constructor(
    private userRepo: UserRepository,
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async deactivate(
    userId: string,
    ip: string,
    userAgent: string,
  ): Promise<{ success: boolean; message: string }> {
    await this.userRepo.update(userId, { status: 'deactivated' });
    await this.sessionRepo.revokeAllUserSessions(userId);
    await this.refreshTokenRepo.revokeAllForUser(userId);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'account_deactivated',
      ipAddress: ip,
      userAgent,
    });

    return { success: true, message: 'Account deactivated successfully' };
  }

  public async softDelete(
    userId: string,
    ip: string,
    userAgent: string,
  ): Promise<{ success: boolean; message: string }> {
    await this.userRepo.softDelete(userId);
    await this.sessionRepo.revokeAllUserSessions(userId);
    await this.refreshTokenRepo.revokeAllForUser(userId);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'account_deleted',
      ipAddress: ip,
      userAgent,
    });

    return { success: true, message: 'Account deleted successfully' };
  }
}
