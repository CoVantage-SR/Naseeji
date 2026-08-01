import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';

export interface LogoutAllDevicesCommand {
  userId: string;
  ipAddress: string;
  userAgent: string;
}

export class LogoutAllDevicesUseCase {
  constructor(
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: LogoutAllDevicesCommand): Promise<void> {
    const userSessions = await this.sessionRepo.findByUserId(command.userId);
    await this.sessionRepo.revokeAllUserSessions(command.userId);

    for (const sess of userSessions) {
      await this.refreshTokenRepo.revokeAllSessionTokens(sess.id.value);
    }

    await this.auditLogService.log(
      AuditAction.LOGOUT_ALL_DEVICES,
      command.ipAddress,
      command.userAgent,
      command.userId,
      { totalSessionsRevoked: userSessions.length },
    );
  }
}
