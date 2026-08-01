import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { IOtpRepository } from '../../otp/domain/repositories/otp.repository.interface.js';
import { Otp } from '../../otp/domain/entities/otp.entity.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { NotFoundException } from '@core/errors/not-found.exception.js';

export interface ForgotPasswordCommand {
  phone: string;
  ipAddress: string;
  userAgent: string;
}

export class ForgotPasswordUseCase {
  constructor(
    private userRepo: IUserRepository,
    private otpRepo: IOtpRepository,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: ForgotPasswordCommand): Promise<Otp> {
    const user = await this.userRepo.findByPhone(command.phone);
    if (!user) {
      throw new NotFoundException('No user found registered with this phone number');
    }

    const otp = Otp.create(user.phone.value);
    await this.otpRepo.save(otp);

    await this.auditLogService.log(
      AuditAction.OTP_GENERATED,
      command.ipAddress,
      command.userAgent,
      user.id,
      { reason: 'Forgot password request' },
    );

    return otp;
  }
}
