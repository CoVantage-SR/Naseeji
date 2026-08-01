import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';

export interface LogoutCommand {
  sessionId: string;
  userId: string;
  ipAddress: string;
  userAgent: string;
}

export class LogoutUseCase {
  constructor(
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: LogoutCommand): Promise<void> {
    await this.sessionRepo.revokeSession(command.sessionId);
    await this.refreshTokenRepo.revokeAllSessionTokens(command.sessionId);

    await this.auditLogService.log(
      AuditAction.LOGOUT_CURRENT_DEVICE,
      command.ipAddress,
      command.userAgent,
      command.userId,
      { sessionId: command.sessionId },
    );
  }
}
