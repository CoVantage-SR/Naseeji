import crypto from 'crypto';
import jwt from 'jsonwebtoken';
import bcrypt from 'bcrypt';
import { GoogleOAuthService } from '../services/google-auth.service.js';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import { DeviceRepository, RegisterDeviceDto } from '../../infrastructure/repositories/device.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export interface GoogleLoginDto {
  idToken: string;
  accountType?: 'factory' | 'supplier';
  deviceInfo: RegisterDeviceDto;
}

export class GoogleLoginUseCase {
  constructor(
    private googleAuthService: GoogleOAuthService,
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private supplierRepo: SupplierRepository,
    private walletRepo: WalletRepository,
    private deviceRepo: DeviceRepository,
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
    private jwtSecret: string,
  ) {}

  public async execute(dto: GoogleLoginDto): Promise<Record<string, unknown>> {
    const googlePayload = await this.googleAuthService.verifyIdToken(dto.idToken);
    let user = await this.userRepo.findByEmail(googlePayload.email);

    let role = dto.accountType || 'factory';

    if (!user) {
      // First time Google Login - Auto Create User & Profile
      const userId = crypto.randomUUID();
      const dummyPasswordHash = await bcrypt.hash(crypto.randomBytes(16).toString('hex'), 12);

      user = await this.userRepo.create({
        _id: userId,
        phone: `+201${Math.floor(100000000 + Math.random() * 900000000)}`,
        email: googlePayload.email,
        passwordHash: dummyPasswordHash,
        role: role as 'factory' | 'supplier',
        status: 'active',
        isEmailVerified: true,
        isPhoneVerified: false,
      });

      if (role === 'factory') {
        await this.factoryRepo.create({
          _id: crypto.randomUUID(),
          userId,
          companyName: googlePayload.name || 'Google Factory',
          factoryType: 'apparel',
          governorate: 'Cairo',
          city: 'Cairo',
          address: 'Cairo Industrial Zone',
          commercialRegistration: `CR-${Math.floor(100000 + Math.random() * 900000)}`,
          taxNumber: `TAX-${Math.floor(100000 + Math.random() * 900000)}`,
          verificationStatus: 'pending',
        });
      } else {
        await this.supplierRepo.create({
          _id: crypto.randomUUID(),
          userId,
          companyName: googlePayload.name || 'Google Supplier',
          supplierType: 'fabric_manufacturer',
          governorate: 'Cairo',
          city: 'Cairo',
          address: 'Cairo Textile Hub',
          commercialRegistration: `CR-${Math.floor(100000 + Math.random() * 900000)}`,
          taxNumber: `TAX-${Math.floor(100000 + Math.random() * 900000)}`,
          verificationStatus: 'pending',
        });
      }

      await this.walletRepo.create({
        _id: crypto.randomUUID(),
        userId,
        balance: 0,
        currency: 'EGP',
        points: 100,
      });
    } else {
      role = user.role;
    }

    // Register / Update Device Security Context
    await this.deviceRepo.upsertDevice({
      ...dto.deviceInfo,
      userId: user._id,
    });

    // Create Session
    const sessionId = crypto.randomUUID();
    await this.sessionRepo.create({
      _id: sessionId,
      userId: user._id,
      deviceId: dto.deviceInfo.deviceId,
      deviceInfo: `${dto.deviceInfo.deviceName} (${dto.deviceInfo.deviceType || 'android'})`,
      ipAddress: dto.deviceInfo.ipAddress,
      country: dto.deviceInfo.country || 'Egypt',
      isRevoked: false,
      lastActiveAt: new Date(),
      expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
    });

    // Generate JWT Access & Refresh Tokens
    const accessToken = jwt.sign(
      { sub: user._id, role: user.role, email: user.email, phone: user.phone, sessionId },
      this.jwtSecret,
      { expiresIn: '15m' },
    );

    const refreshTokenRaw = crypto.randomBytes(40).toString('hex');
    const refreshTokenHash = crypto.createHash('sha256').update(refreshTokenRaw).digest('hex');
    const familyId = crypto.randomUUID();

    await this.refreshTokenRepo.create({
      _id: crypto.randomUUID(),
      userId: user._id,
      sessionId,
      tokenHash: refreshTokenHash,
      familyId,
      isUsed: false,
      isRevoked: false,
      expiresAt: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
    });

    // Fetch Profile & Wallet
    const profile =
      user.role === 'factory'
        ? await this.factoryRepo.findByUserId(user._id)
        : await this.supplierRepo.findByUserId(user._id);

    const wallet = await this.walletRepo.findByUserId(user._id);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: user._id,
      action: 'google_login',
      ipAddress: dto.deviceInfo.ipAddress,
      userAgent: dto.deviceInfo.deviceName,
    });

    return {
      tokens: {
        accessToken,
        refreshToken: refreshTokenRaw,
        tokenType: 'Bearer',
        expiresInSeconds: 15 * 60,
      },
      user: {
        id: user._id,
        email: user.email,
        phone: user.phone,
        role: user.role,
        status: user.status,
        isEmailVerified: user.isEmailVerified,
        isPhoneVerified: user.isPhoneVerified,
      },
      profile,
      wallet: wallet
        ? {
            balance: wallet.balance,
            currency: wallet.currency,
            points: wallet.points,
          }
        : { balance: 0, currency: 'EGP', points: 100 },
    };
  }
}
