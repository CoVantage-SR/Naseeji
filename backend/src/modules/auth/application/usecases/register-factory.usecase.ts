import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import { VerificationRequestRepository } from '../../infrastructure/repositories/verification-request.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';
import { OtpRepository } from '../../infrastructure/repositories/otp.repository.js';
import { WinstonLogger } from '../../../../core/logger/winston.logger.js';

export interface RegisterFactoryDto {
  phone: string;
  email: string;
  password: string;
  companyName: string;
  factoryType: string;
  governorate: string;
  city: string;
  address: string;
  commercialRegistration: string;
  taxNumber: string;
  logoUrl?: string;
  ipAddress: string;
  userAgent: string;
}

export class RegisterFactoryUseCase {
  constructor(
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private walletRepo: WalletRepository,
    private verificationRepo: VerificationRequestRepository,
    private securityLogRepo: SecurityLogRepository,
    private otpRepo?: OtpRepository,
  ) {}

  private get logger() {
    return WinstonLogger.getInstance();
  }

  public async execute(dto: RegisterFactoryDto): Promise<Record<string, unknown>> {
    // 1. Normalize identifiers
    const normalizedEmail = dto.email.toLowerCase().trim();
    const normalizedPhone = dto.phone.replace(/\s+/g, '').replace(/[^\d+]/g, '');

    // 2. Check duplicate email or phone
    const existingEmail = await this.userRepo.findByEmail(normalizedEmail);
    if (existingEmail) {
      throw new Error('Email is already registered');
    }

    const existingPhone = await this.userRepo.findByPhone(normalizedPhone);
    if (existingPhone) {
      throw new Error('Phone number is already registered');
    }

    // 3. Check duplicate CR or Tax Number
    const existingCr = await this.factoryRepo.findByCommercialRegistration(
      dto.commercialRegistration,
    );
    if (existingCr) {
      throw new Error('Commercial Registration number is already registered');
    }

    const existingTax = await this.factoryRepo.findByTaxNumber(dto.taxNumber);
    if (existingTax) {
      throw new Error('Tax Number is already registered');
    }

    // 4. Hash Password
    const rounds = parseInt(process.env.PASSWORD_HASH_ROUNDS || '12', 10);
    const passwordHash = await bcrypt.hash(dto.password, rounds);
    const userId = crypto.randomUUID();
    const factoryId = crypto.randomUUID();
    const walletId = crypto.randomUUID();

    // 5. Create Factory Record
    const factory = await this.factoryRepo.create({
      _id: factoryId,
      userId,
      companyName: dto.companyName,
      factoryType: dto.factoryType,
      governorate: dto.governorate,
      city: dto.city,
      address: dto.address,
      commercialRegistration: dto.commercialRegistration,
      taxNumber: dto.taxNumber,
      logoUrl: dto.logoUrl,
      verificationStatus: 'pending',
    });

    // 6. Create Wallet
    const wallet = await this.walletRepo.create({
      _id: walletId,
      userId,
      balance: 0,
      pointsBalance: 100,
      currency: 'EGP',
    });

    // 7. Create User Record
    const user = await this.userRepo.create({
      _id: userId,
      phone: normalizedPhone,
      email: normalizedEmail,
      passwordHash,
      role: 'factory',
      status: 'pending',
      isEmailVerified: false,
      isPhoneVerified: false,
      factoryId,
      walletId,
    });

    // 8. Create Verification Request
    await this.verificationRepo.create({
      _id: crypto.randomUUID(),
      userId,
      targetId: factoryId,
      entityType: 'factory',
      status: 'pending',
      commercialRegistration: dto.commercialRegistration,
      taxNumber: dto.taxNumber,
      documents: [],
    });

    // 9. Log Security Audit Action
    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'user_registered',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
      metadata: { role: 'factory', companyName: dto.companyName },
    });

    // 10. Dispatch phone verification OTP (non-blocking)
    let debugOtp: string | undefined;
    if (this.otpRepo) {
      try {
        const { code } = await this.otpRepo.generateOtp(normalizedPhone, 'phone_verification', userId);
        debugOtp = process.env.NODE_ENV !== 'production' ? code : undefined;
        this.logger.info(`📱 Phone verification OTP generated for factory user ${userId}`);
      } catch (otpErr) {
        // OTP failure is non-fatal — user can request resend
        this.logger.warn(`OTP generation warning: ${(otpErr as Error).message}`);
      }
    }

    return {
      user: {
        id: user._id,
        phone: user.phone,
        email: user.email,
        role: user.role,
        status: user.status,
        isEmailVerified: user.isEmailVerified,
        isPhoneVerified: user.isPhoneVerified,
      },
      factory: {
        id: factory._id,
        companyName: factory.companyName,
        factoryType: factory.factoryType,
        governorate: factory.governorate,
        city: factory.city,
        address: factory.address,
        commercialRegistration: factory.commercialRegistration,
        taxNumber: factory.taxNumber,
        verificationStatus: factory.verificationStatus,
      },
      wallet: {
        id: wallet._id,
        balance: wallet.balance,
        pointsBalance: wallet.pointsBalance,
        currency: wallet.currency,
      },
      nextStep: {
        action: 'verify_phone',
        message: 'A verification code has been sent to your phone number.',
        ...(debugOtp ? { debugOtp } : {}),
      },
    };
  }
}
