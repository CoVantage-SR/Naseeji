import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';
import { JwtService } from '../../security/services/jwt.service.js';

export interface LoginDto {
  identifier: string;
  password: string;
  rememberMe?: boolean;
  ipAddress: string;
  userAgent: string;
  deviceId?: string;
}

/** Statuses that block login entirely */
const BLOCKED_STATUSES = ['deactivated', 'deleted', 'blocked', 'suspended', 'rejected'] as const;

export class LoginUseCase {
  private readonly jwtService: JwtService;

  constructor(
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private supplierRepo: SupplierRepository,
    private walletRepo: WalletRepository,
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
    // jwtSecret param kept for backward compatibility — JwtService reads from env internally
    _jwtSecret?: string,
  ) {
    this.jwtService = new JwtService();
  }

  public async execute(dto: LoginDto): Promise<Record<string, unknown>> {
    const isEmail = dto.identifier.includes('@');
    const normalizedIdentifier = isEmail
      ? dto.identifier.toLowerCase().trim()
      : dto.identifier.replace(/\s+/g, '');

    const user = isEmail
      ? await this.userRepo.findByEmail(normalizedIdentifier)
      : await this.userRepo.findByPhone(normalizedIdentifier);

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

    // Block all non-active/non-pending statuses
    if (BLOCKED_STATUSES.includes(user.status as (typeof BLOCKED_STATUSES)[number])) {
      await this.securityLogRepo.logAction({
        _id: crypto.randomUUID(),
        userId: user._id,
        action: 'login_failure',
        ipAddress: dto.ipAddress,
        userAgent: dto.userAgent,
        metadata: { reason: `Account status: ${user.status}` },
      });
      throw new Error(`Account access denied. Status: ${user.status}`);
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

    // Determine token TTL (rememberMe extends refresh to 30d, otherwise 7d)
    const refreshDays = dto.rememberMe ? 30 : 7;
    const expiresAt = new Date(Date.now() + refreshDays * 24 * 60 * 60 * 1000);

    const sessionId = crypto.randomUUID();
    const familyId = crypto.randomUUID();
    const deviceId = dto.deviceId || crypto.randomUUID();

    // Issue tokens via JwtService (access with JWT_SECRET, refresh with JWT_REFRESH_SECRET)
    const { accessToken, refreshToken: refreshTokenRaw, accessTokenExpiresIn } =
      this.jwtService.issueTokens(user._id, sessionId, user.role, [user.role]);

    const refreshTokenHash = crypto
      .createHash('sha256')
      .update(refreshTokenRaw)
      .digest('hex');

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

    // Save Refresh Token (hashed)
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
        expiresInSeconds: accessTokenExpiresIn,
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
