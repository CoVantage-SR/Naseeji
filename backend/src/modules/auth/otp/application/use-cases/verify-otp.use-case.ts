import { IOtpRepository } from '../../domain/repositories/otp.repository.interface.js';
import { OtpInvalidException } from '../../../domain/errors/auth-domain.exceptions.js';

export interface VerifyOtpCommand {
  phone: string;
  code: string;
}

export class VerifyOtpUseCase {
  constructor(private otpRepo: IOtpRepository) {}

  public async execute(command: VerifyOtpCommand): Promise<boolean> {
    const latestOtp = await this.otpRepo.findLatestByPhone(command.phone);
    if (!latestOtp) {
      throw new OtpInvalidException('No active OTP found for this phone number');
    }

    const isValid = latestOtp.verify(command.code);
    await this.otpRepo.save(latestOtp);
    return isValid;
  }
}
