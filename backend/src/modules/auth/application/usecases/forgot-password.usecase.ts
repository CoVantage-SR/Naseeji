import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { OtpRepository } from '../../infrastructure/repositories/otp.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export interface ForgotPasswordDto {
  target: string;
  ipAddress: string;
  userAgent: string;
}

export interface ResetPasswordDto {
  target: string;
  otpCode: string;
  newPassword: string;
  ipAddress: string;
  userAgent: string;
}

export class ForgotPasswordUseCase {
  constructor(
    private userRepo: UserRepository,
    private otpRepo: OtpRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(dto: ForgotPasswordDto): Promise<Record<string, unknown>> {
    const isEmail = dto.target.includes('@');
    const user = isEmail
      ? await this.userRepo.findByEmail(dto.target)
      : await this.userRepo.findByPhone(dto.target);

    if (!user) {
      return { success: true, message: 'If account exists, an OTP code has been sent.' };
    }

    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    const codeHash = await bcrypt.hash(otpCode, 10);
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000);

    await this.otpRepo.create({
      _id: crypto.randomUUID(),
      userId: user._id,
      target: dto.target,
      type: 'password_reset',
      codeHash,
      expiresAt,
      isUsed: false,
      attempts: 0,
    });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: user._id,
      action: 'password_reset_request',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
    });

    return {
      success: true,
      message: 'OTP code has been generated and sent.',
      debugOtp: process.env.NODE_ENV !== 'production' ? otpCode : undefined,
    };
  }
}

export class ResetPasswordUseCase {
  constructor(
    private userRepo: UserRepository,
    private otpRepo: OtpRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(dto: ResetPasswordDto): Promise<{ success: boolean; message: string }> {
    const validOtp = await this.otpRepo.findValidOtp(dto.target, 'password_reset');
    if (!validOtp) {
      throw new Error('Invalid or expired OTP code');
    }

    const isValid = await bcrypt.compare(dto.otpCode, validOtp.codeHash);
    if (!isValid) {
      await this.otpRepo.incrementAttempts(validOtp._id);
      throw new Error('Invalid OTP code');
    }

    const user = validOtp.userId
      ? await this.userRepo.findById(validOtp.userId)
      : dto.target.includes('@')
        ? await this.userRepo.findByEmail(dto.target)
        : await this.userRepo.findByPhone(dto.target);

    if (!user) {
      throw new Error('User not found');
    }

    const newPasswordHash = await bcrypt.hash(dto.newPassword, 12);
    await this.userRepo.update(user._id, { passwordHash: newPasswordHash });
    await this.otpRepo.markAsUsed(validOtp._id);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: user._id,
      action: 'password_reset_success',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
    });

    return { success: true, message: 'Password has been reset successfully' };
  }
}
