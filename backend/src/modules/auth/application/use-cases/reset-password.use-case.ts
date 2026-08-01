import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { IOtpRepository } from '../../otp/domain/repositories/otp.repository.interface.js';
import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { PasswordService } from '../../security/services/password.service.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { Password } from '../../identity/domain/value-objects/password.vo.js';
import { OtpInvalidException } from '../../domain/errors/auth-domain.exceptions.js';

export interface ResetPasswordCommand {
  phone: string;
  otpCode: string;
  newPassword: string;
  ipAddress: string;
  userAgent: string;
}

export class ResetPasswordUseCase {
  constructor(
    private userRepo: IUserRepository,
    private otpRepo: IOtpRepository,
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private passwordService: PasswordService,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: ResetPasswordCommand): Promise<void> {
    const user = await this.userRepo.findByPhone(command.phone);
    if (!user) {
      throw new OtpInvalidException('User not found');
    }

    const latestOtp = await this.otpRepo.findLatestByPhone(command.phone);
    if (!latestOtp) {
      throw new OtpInvalidException('No active OTP found for password reset');
    }

    latestOtp.verify(command.otpCode);
    await this.otpRepo.save(latestOtp);

    // Hash & update password
    const plainPwd = Password.createPlain(command.newPassword);
    const hashedPwd = await this.passwordService.hashPassword(plainPwd);

    (user as unknown as { props: { password: Password } }).props.password = hashedPwd;
    await this.userRepo.save(user);

    // Revoke all existing sessions & refresh tokens
    await this.sessionRepo.revokeAllUserSessions(user.id);
    const userSessions = await this.sessionRepo.findByUserId(user.id);
    for (const sess of userSessions) {
      await this.refreshTokenRepo.revokeAllSessionTokens(sess.id.value);
    }

    await this.auditLogService.log(
      AuditAction.PASSWORD_RESET,
      command.ipAddress,
      command.userAgent,
      user.id,
      { reason: 'User initiated password reset' },
    );
  }
}
