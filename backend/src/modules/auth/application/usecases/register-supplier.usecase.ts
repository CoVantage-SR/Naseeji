import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import { VerificationRequestRepository } from '../../infrastructure/repositories/verification-request.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

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
  ) {}

  public async execute(dto: RegisterSupplierDto) {
    // 1. Duplicate Checks
    const existingEmail = await this.userRepo.findByEmail(dto.email);
    if (existingEmail) {
      throw new Error('Email is already registered');
    }

    const existingPhone = await this.userRepo.findByPhone(dto.phone);
    if (existingPhone) {
      throw new Error('Phone number is already registered');
    }

    const existingCr = await this.supplierRepo.findByCommercialRegistration(dto.commercialRegistration);
    if (existingCr) {
      throw new Error('Commercial Registration number is already registered');
    }

    const existingTax = await this.supplierRepo.findByTaxNumber(dto.taxNumber);
    if (existingTax) {
      throw new Error('Tax Number is already registered');
    }

    // 2. Hash Password & Prepare IDs
    const passwordHash = await bcrypt.hash(dto.password, 12);
    const userId = crypto.randomUUID();
    const supplierId = crypto.randomUUID();
    const walletId = crypto.randomUUID();

    // 3. Create Supplier Profile
    const supplier = await this.supplierRepo.create({
      _id: supplierId,
      userId,
      companyName: dto.companyName,
      supplierCategory: dto.supplierCategory,
      phone: dto.phone,
      email: dto.email,
      commercialRegistration: dto.commercialRegistration,
      taxNumber: dto.taxNumber,
      country: dto.country || 'Egypt',
      governorate: dto.governorate,
      address: dto.address,
      verificationStatus: 'pending',
      subscriptionStatus: 'inactive',
    });

    // 4. Create Wallet
    const wallet = await this.walletRepo.create({
      _id: walletId,
      userId,
      balance: 0,
      pointsBalance: 150, // Initial bonus for suppliers
      currency: 'EGP',
    });

    // 5. Create User Record
    const user = await this.userRepo.create({
      _id: userId,
      phone: dto.phone,
      email: dto.email.toLowerCase(),
      passwordHash,
      role: 'supplier',
      status: 'pending',
      isEmailVerified: false,
      isPhoneVerified: false,
      supplierId,
      walletId,
    });

    // 6. Create Verification Request
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

    // 7. Log Security Action
    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'login_success',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
      metadata: { role: 'supplier', companyName: dto.companyName },
    });

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
    };
  }
}
