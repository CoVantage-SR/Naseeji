import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { GoogleOAuthService } from '../services/google-auth.service.js';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import {
  DeviceRepository,
  RegisterDeviceDto,
} from '../../infrastructure/repositories/device.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';
import { JwtService } from '../../security/services/jwt.service.js';

export interface GoogleLoginDto {
  idToken: string;
  accountType?: 'factory' | 'supplier';
  deviceInfo: RegisterDeviceDto;
}

export class GoogleLoginUseCase {
  private readonly jwtService: JwtService;

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
    // jwtSecret kept for backward compatibility — JwtService reads from env
    _jwtSecret?: string,
  ) {
    this.jwtService = new JwtService();
  }

  public async execute(dto: GoogleLoginDto): Promise<Record<string, unknown>> {
    const googlePayload = await this.googleAuthService.verifyIdToken(dto.idToken);
    let user = await this.userRepo.findByEmail(googlePayload.email);

    let role: 'factory' | 'supplier';

    if (!user) {
      // New user — accountType is REQUIRED
      if (!dto.accountType) {
        throw new Error(
          'accountType is required for new Google Sign-In registrations. Please specify "factory" or "supplier".',
        );
      }
      role = dto.accountType;

      const userId = crypto.randomUUID();
      const dummyPasswordHash = await bcrypt.hash(crypto.randomBytes(16).toString('hex'), 12);

      user = await this.userRepo.create({
        _id: userId,
        phone: `+201${Math.floor(100000000 + Math.random() * 900000000)}`,
        email: googlePayload.email,
        passwordHash: dummyPasswordHash,
        role,
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
          supplierCategory: 'fabric_manufacturer',
          phone: user.phone,
          email: user.email,
          governorate: 'Cairo',
          address: 'Cairo Textile Hub',
          commercialRegistration: `CR-${Math.floor(100000 + Math.random() * 900000)}`,
          taxNumber: `TAX-${Math.floor(100000 + Math.random() * 900000)}`,
          verificationStatus: 'pending',
          subscriptionStatus: 'trial',
        });
      }

      await this.walletRepo.create({
        _id: crypto.randomUUID(),
        userId,
        balance: 0,
        currency: 'EGP',
        pointsBalance: 100,
      });
    } else {
      // Existing user — use their existing role
      if (user.role !== 'factory' && user.role !== 'supplier') {
        throw new Error('Google Sign-In is only available for factory and supplier accounts.');
      }
      role = user.role;
    }

    await this.deviceRepo.upsertDevice({
      ...dto.deviceInfo,
      userId: user._id,
    });

    const sessionId = crypto.randomUUID();
    const familyId = crypto.randomUUID();

    // Issue tokens via JwtService
    const { accessToken, refreshToken: refreshTokenRaw, accessTokenExpiresIn } =
      this.jwtService.issueTokens(user._id, sessionId, role, [role]);

    const refreshTokenHash = crypto.createHash('sha256').update(refreshTokenRaw).digest('hex');
    const refreshExpiry = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);

    await this.sessionRepo.create({
      _id: sessionId,
      userId: user._id,
      refreshTokenHash,
      deviceId: dto.deviceInfo.deviceId,
      deviceInfo: {
        userAgent: dto.deviceInfo.deviceName,
        os: dto.deviceInfo.osVersion,
        device: dto.deviceInfo.deviceType,
      },
      ipAddress: dto.deviceInfo.ipAddress,
      country: dto.deviceInfo.country || 'Egypt',
      isRevoked: false,
      lastActiveAt: new Date(),
      expiresAt: refreshExpiry,
    });

    await this.refreshTokenRepo.create({
      _id: crypto.randomUUID(),
      userId: user._id,
      sessionId,
      tokenHash: refreshTokenHash,
      familyId,
      isUsed: false,
      isRevoked: false,
      expiresAt: refreshExpiry,
    });

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
        expiresInSeconds: accessTokenExpiresIn,
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
            points: wallet.pointsBalance,
          }
        : { balance: 0, currency: 'EGP', points: 100 },
    };
  }
}
