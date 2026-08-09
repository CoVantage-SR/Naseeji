import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import { VerificationRequestRepository } from '../../infrastructure/repositories/verification-request.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';
import { OtpRepository } from '../../infrastructure/repositories/otp.repository.js';
import { WinstonLogger } from '../../../../core/logger/winston.logger.js';

export interface RegisterSupplierDto {
  phone: string;
  email: string;
  password: string;
  companyName: string;
  supplierCategory: string;
  commercialRegistration: string;
  taxNumber: string;
  country: string;
  governorate: string;
  address: string;
  ipAddress: string;
  userAgent: string;
}

export class RegisterSupplierUseCase {
  constructor(
    private userRepo: UserRepository,
    private supplierRepo: SupplierRepository,
    private walletRepo: WalletRepository,
    private verificationRepo: VerificationRequestRepository,
    private securityLogRepo: SecurityLogRepository,
    private otpRepo?: OtpRepository,
  ) {}

  private get logger() {
    return WinstonLogger.getInstance();
  }

  public async execute(dto: RegisterSupplierDto): Promise<Record<string, unknown>> {
    // 1. Normalize identifiers
    const normalizedEmail = dto.email.toLowerCase().trim();
    const normalizedPhone = dto.phone.replace(/\s+/g, '').replace(/[^\d+]/g, '');

    // 2. Duplicate Checks
    const existingEmail = await this.userRepo.findByEmail(normalizedEmail);
    if (existingEmail) {
      throw new Error('Email is already registered');
    }

    const existingPhone = await this.userRepo.findByPhone(normalizedPhone);
    if (existingPhone) {
      throw new Error('Phone number is already registered');
    }

    const existingCr = await this.supplierRepo.findByCommercialRegistration(
      dto.commercialRegistration,
    );
    if (existingCr) {
      throw new Error('Commercial Registration number is already registered');
    }

    const existingTax = await this.supplierRepo.findByTaxNumber(dto.taxNumber);
    if (existingTax) {
      throw new Error('Tax Number is already registered');
    }

    // 3. Hash Password & Prepare IDs
    const rounds = parseInt(process.env.PASSWORD_HASH_ROUNDS || '12', 10);
    const passwordHash = await bcrypt.hash(dto.password, rounds);
    const userId = crypto.randomUUID();
    const supplierId = crypto.randomUUID();
    const walletId = crypto.randomUUID();

    // 4. Create Supplier Profile
    const supplier = await this.supplierRepo.create({
      _id: supplierId,
      userId,
      companyName: dto.companyName,
      supplierCategory: dto.supplierCategory,
      phone: normalizedPhone,
      email: normalizedEmail,
      commercialRegistration: dto.commercialRegistration,
      taxNumber: dto.taxNumber,
      country: dto.country || 'Egypt',
      governorate: dto.governorate,
      address: dto.address,
      verificationStatus: 'pending',
      subscriptionStatus: 'inactive',
    });

    // 5. Create Wallet
    const wallet = await this.walletRepo.create({
      _id: walletId,
      userId,
      balance: 0,
      pointsBalance: 150,
      currency: 'EGP',
    });

    // 6. Create User Record
    const user = await this.userRepo.create({
      _id: userId,
      phone: normalizedPhone,
      email: normalizedEmail,
      passwordHash,
      role: 'supplier',
      status: 'pending',
      isEmailVerified: false,
      isPhoneVerified: false,
      supplierId,
      walletId,
    });

    // 7. Create Verification Request
    await this.verificationRepo.create({
      _id: crypto.randomUUID(),
      userId,
      targetId: supplierId,
      entityType: 'supplier',
      status: 'pending',
      commercialRegistration: dto.commercialRegistration,
      taxNumber: dto.taxNumber,
      documents: [],
    });

    // 8. Log Security Action
    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'user_registered',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
      metadata: { role: 'supplier', companyName: dto.companyName },
    });

    // 9. Dispatch phone verification OTP (non-blocking)
    let debugOtp: string | undefined;
    if (this.otpRepo) {
      try {
        const { code } = await this.otpRepo.generateOtp(normalizedPhone, 'phone_verification', userId);
        debugOtp = process.env.NODE_ENV !== 'production' ? code : undefined;
        this.logger.info(`📱 Phone verification OTP generated for supplier user ${userId}`);
      } catch (otpErr) {
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
      supplier: {
        id: supplier._id,
        companyName: supplier.companyName,
        supplierCategory: supplier.supplierCategory,
        country: supplier.country,
        governorate: supplier.governorate,
        address: supplier.address,
        commercialRegistration: supplier.commercialRegistration,
        taxNumber: supplier.taxNumber,
        verificationStatus: supplier.verificationStatus,
        subscriptionStatus: supplier.subscriptionStatus,
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
