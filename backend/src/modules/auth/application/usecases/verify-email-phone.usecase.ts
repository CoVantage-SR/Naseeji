import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { OtpRepository } from '../../infrastructure/repositories/otp.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export class VerifyEmailPhoneUseCase {
  constructor(
    private userRepo: UserRepository,
    private otpRepo: OtpRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async verifyPhone(userId: string, phone: string, otpCode: string, ip: string, userAgent: string) {
    const validOtp = await this.otpRepo.findValidOtp(phone, 'phone_verification');
    if (!validOtp) {
      throw new Error('Invalid or expired OTP');
    }

    const isValid = await bcrypt.compare(otpCode, validOtp.codeHash);
    if (!isValid) {
      await this.otpRepo.incrementAttempts(validOtp._id);
      throw new Error('Invalid OTP code');
    }

    await this.userRepo.update(userId, { isPhoneVerified: true });
    await this.otpRepo.markAsUsed(validOtp._id);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'otp_verified',
      ipAddress: ip,
      userAgent,
      metadata: { target: phone, type: 'phone' },
    });

    return { success: true, message: 'Phone verified successfully' };
  }

  public async verifyEmail(userId: string, email: string, otpCode: string, ip: string, userAgent: string) {
    const validOtp = await this.otpRepo.findValidOtp(email, 'email_verification');
    if (!validOtp) {
      throw new Error('Invalid or expired OTP');
    }

    const isValid = await bcrypt.compare(otpCode, validOtp.codeHash);
    if (!isValid) {
      await this.otpRepo.incrementAttempts(validOtp._id);
      throw new Error('Invalid OTP code');
    }

    await this.userRepo.update(userId, { isEmailVerified: true });
    await this.otpRepo.markAsUsed(validOtp._id);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'otp_verified',
      ipAddress: ip,
      userAgent,
      metadata: { target: email, type: 'email' },
    });

    return { success: true, message: 'Email verified successfully' };
  }

  public async resendOtp(target: string, type: 'phone_verification' | 'email_verification' | 'password_reset', ip: string, userAgent: string) {
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    const codeHash = await bcrypt.hash(otpCode, 10);
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000);

    await this.otpRepo.create({
      _id: crypto.randomUUID(),
      target,
      type,
      codeHash,
      expiresAt,
      isUsed: false,
      attempts: 0,
    });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      action: 'otp_requested',
      ipAddress: ip,
      userAgent,
      metadata: { target, type },
    });

    return {
      success: true,
      message: 'New OTP has been sent.',
      debugOtp: process.env.NODE_ENV !== 'production' ? otpCode : undefined,
    };
  }
}
