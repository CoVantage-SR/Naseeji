import crypto from 'crypto';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export interface LoginDto {
  identifier: string;
  password: string;
  rememberMe?: boolean;
  ipAddress: string;
  userAgent: string;
  deviceId?: string;
}

export class LoginUseCase {
  constructor(
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private supplierRepo: SupplierRepository,
    private walletRepo: WalletRepository,
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
    private jwtSecret: string,
  ) {}

  public async execute(dto: LoginDto): Promise<Record<string, unknown>> {
    const isEmail = dto.identifier.includes('@');
    const user = isEmail
      ? await this.userRepo.findByEmail(dto.identifier)
      : await this.userRepo.findByPhone(dto.identifier);

    if (!user) {
      await this.securityLogRepo.logAction({
        _id: crypto.randomUUID(),
        action: 'login_failure',
        ipAddress: dto.ipAddress,
        userAgent: dto.userAgent,
        metadata: { identifier: dto.identifier, reason: 'User not found' },
      });
      throw new Error('Invalid credentials');
    }

    if (user.status === 'deactivated' || user.status === 'deleted') {
      throw new Error('Account is deactivated or deleted');
    }

    // Verify Password
    const isPasswordValid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!isPasswordValid) {
      await this.securityLogRepo.logAction({
        _id: crypto.randomUUID(),
        userId: user._id,
        action: 'login_failure',
        ipAddress: dto.ipAddress,
        userAgent: dto.userAgent,
        metadata: { reason: 'Incorrect password' },
      });
      throw new Error('Invalid credentials');
    }

    // Generate JWT Access & Refresh Tokens
    const accessTokenExpiryMinutes = 15;
    const refreshTokenExpiryDays = dto.rememberMe ? 30 : 7;

    const accessToken = jwt.sign(
      { sub: user._id, role: user.role, email: user.email, phone: user.phone },
      this.jwtSecret,
      { expiresIn: `${accessTokenExpiryMinutes}m` },
    );

    const refreshTokenRaw = crypto.randomBytes(40).toString('hex');
    const refreshTokenHash = crypto.createHash('sha256').update(refreshTokenRaw).digest('hex');

    const sessionId = crypto.randomUUID();
    const familyId = crypto.randomUUID();
    const deviceId = dto.deviceId || crypto.randomUUID();

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + refreshTokenExpiryDays);

    // Save Session
    await this.sessionRepo.create({
      _id: sessionId,
      userId: user._id,
      refreshTokenHash,
      deviceId,
      deviceInfo: { userAgent: dto.userAgent },
      ipAddress: dto.ipAddress,
      isRevoked: false,
      expiresAt,
      lastActiveAt: new Date(),
    });

    // Save Refresh Token
    await this.refreshTokenRepo.create({
      _id: crypto.randomUUID(),
      userId: user._id,
      sessionId,
      tokenHash: refreshTokenHash,
      familyId,
      isUsed: false,
      isRevoked: false,
      expiresAt,
    });

    // Fetch Profile & Wallet
    let profile: unknown = null;
    if (user.role === 'factory') {
      profile = await this.factoryRepo.findByUserId(user._id);
    } else if (user.role === 'supplier') {
      profile = await this.supplierRepo.findByUserId(user._id);
    }

    const wallet = await this.walletRepo.findByUserId(user._id);

    // Audit log
    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: user._id,
      action: 'login_success',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
      metadata: { role: user.role, rememberMe: !!dto.rememberMe },
    });

    return {
      tokens: {
        accessToken,
        refreshToken: refreshTokenRaw,
        tokenType: 'Bearer',
        expiresInSeconds: accessTokenExpiryMinutes * 60,
      },
      user: {
        id: user._id,
        phone: user.phone,
        email: user.email,
        role: user.role,
        status: user.status,
        isEmailVerified: user.isEmailVerified,
        isPhoneVerified: user.isPhoneVerified,
      },
      profile,
      wallet: wallet
        ? {
            id: wallet._id,
            balance: wallet.balance,
            pointsBalance: wallet.pointsBalance,
            currency: wallet.currency,
          }
        : null,
    };
  }
}
