import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { PasswordService } from '../../security/services/password.service.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { Password } from '../../identity/domain/value-objects/password.vo.js';
import { NotFoundException } from '@core/errors/not-found.exception.js';

export interface AdminResetPasswordCommand {
  adminUserId: string;
  targetUserId: string;
  newPassword: string;
  ipAddress: string;
  userAgent: string;
}

export class AdminResetPasswordUseCase {
  constructor(
    private userRepo: IUserRepository,
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private passwordService: PasswordService,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: AdminResetPasswordCommand): Promise<void> {
    const user = await this.userRepo.findById(command.targetUserId);
    if (!user) {
      throw new NotFoundException(`User with ID ${command.targetUserId} not found`);
    }

    const plainPwd = Password.createPlain(command.newPassword);
    const hashedPwd = await this.passwordService.hashPassword(plainPwd);

    (user as unknown as { props: { password: Password } }).props.password = hashedPwd;
    await this.userRepo.save(user);

    const sessions = await this.sessionRepo.findByUserId(user.id);
    await this.sessionRepo.revokeAllUserSessions(user.id);
    for (const sess of sessions) {
      await this.refreshTokenRepo.revokeAllSessionTokens(sess.id.value);
    }

    await this.auditLogService.log(
      AuditAction.ADMIN_ACTION,
      command.ipAddress,
      command.userAgent,
      command.adminUserId,
      { action: 'ADMIN_RESET_PASSWORD', targetUserId: user.id },
    );
  }
}
