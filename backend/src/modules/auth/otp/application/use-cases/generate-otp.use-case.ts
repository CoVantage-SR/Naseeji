import { IOtpRepository } from '../../domain/repositories/otp.repository.interface.js';
import { Otp } from '../../domain/entities/otp.entity.js';

export interface GenerateOtpCommand {
  phone: string;
}

export class GenerateOtpUseCase {
  constructor(private otpRepo: IOtpRepository) {}

  public async execute(command: GenerateOtpCommand): Promise<Otp> {
    const otp = Otp.create(command.phone);
    await this.otpRepo.save(otp);
    return otp;
  }
}
