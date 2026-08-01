import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';

export interface ForceLogoutUserCommand {
  adminUserId: string;
  targetUserId: string;
  targetSessionId?: string;
  ipAddress: string;
  userAgent: string;
}

export class ForceLogoutUserUseCase {
  constructor(
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: ForceLogoutUserCommand): Promise<void> {
    if (command.targetSessionId) {
      await this.sessionRepo.revokeSession(command.targetSessionId);
      await this.refreshTokenRepo.revokeAllSessionTokens(command.targetSessionId);
    } else {
      const sessions = await this.sessionRepo.findByUserId(command.targetUserId);
      await this.sessionRepo.revokeAllUserSessions(command.targetUserId);
      for (const sess of sessions) {
        await this.refreshTokenRepo.revokeAllSessionTokens(sess.id.value);
      }
    }

    await this.auditLogService.log(
      AuditAction.ADMIN_ACTION,
      command.ipAddress,
      command.userAgent,
      command.adminUserId,
      {
        action: 'FORCE_LOGOUT',
        targetUserId: command.targetUserId,
        targetSessionId: command.targetSessionId,
      },
    );
  }
}
