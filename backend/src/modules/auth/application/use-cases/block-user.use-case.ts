import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { NotFoundException } from '@core/errors/not-found.exception.js';

export interface BlockUserCommand {
  adminUserId: string;
  targetUserId: string;
  reason: string;
  ipAddress: string;
  userAgent: string;
}

export class BlockUserUseCase {
  constructor(
    private userRepo: IUserRepository,
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: BlockUserCommand): Promise<void> {
    const user = await this.userRepo.findById(command.targetUserId);
    if (!user) {
      throw new NotFoundException(`User with ID ${command.targetUserId} not found`);
    }

    user.block();
    await this.userRepo.save(user);

    // Immediately revoke all sessions for blocked user
    const sessions = await this.sessionRepo.findByUserId(user.id);
    await this.sessionRepo.revokeAllUserSessions(user.id);
    for (const sess of sessions) {
      await this.refreshTokenRepo.revokeAllSessionTokens(sess.id.value);
    }

    await this.auditLogService.log(
      AuditAction.ACCOUNT_BLOCKED,
      command.ipAddress,
      command.userAgent,
      command.adminUserId,
      { targetUserId: user.id, reason: command.reason },
    );
  }
}
