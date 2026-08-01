import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { IDeviceRepository } from '../../security/domain/repositories/device.repository.interface.js';
import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { IOtpRepository } from '../../otp/domain/repositories/otp.repository.interface.js';
import { PasswordService } from '../../security/services/password.service.js';
import { JwtService, IssuedTokens } from '../../security/services/jwt.service.js';
import { FingerprintService } from '../../security/services/fingerprint.service.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { Phone } from '../../identity/domain/value-objects/phone.vo.js';
import { Password } from '../../identity/domain/value-objects/password.vo.js';
import { AccountStatus } from '../../identity/domain/value-objects/account-status.enum.js';
import { Session } from '../../session/domain/entities/session.entity.js';
import { Device } from '../../security/domain/entities/device.entity.js';
import { RefreshTokenEntity } from '../../security/domain/entities/refresh-token.entity.js';
import { Otp } from '../../otp/domain/entities/otp.entity.js';
import { User } from '../../identity/domain/entities/user.entity.js';
import { AuthenticationException } from '@core/errors/auth.exception.js';
import { AuthorizationException } from '@core/errors/forbidden.exception.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface LoginCommand {
  phone: string;
  password?: string;
  platform: string;
  deviceName: string;
  osVersion: string;
  appName: string;
  appVersion: string;
  ipAddress: string;
  userAgent: string;
  isRememberMe?: boolean;
}

export interface LoginResponse {
  user: User;
  tokens?: IssuedTokens;
  requireOtpChallenge?: boolean;
  challengeToken?: string;
}

export class LoginUseCase {
  constructor(
    private userRepo: IUserRepository,
    private deviceRepo: IDeviceRepository,
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private otpRepo: IOtpRepository,
    private passwordService: PasswordService,
    private jwtService: JwtService,
    private fingerprintService: FingerprintService,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: LoginCommand): Promise<LoginResponse> {
    const phone = Phone.create(command.phone);
    const user = await this.userRepo.findByPhone(phone.value);

    if (!user) {
      await this.auditLogService.log(
        AuditAction.LOGIN_FAILED,
        command.ipAddress,
        command.userAgent,
        undefined,
        { reason: 'User not found', phone: command.phone },
      );
      throw new AuthenticationException('Invalid phone number or password');
    }

    // 1. Check Password if set on account
    if (user.password && command.password) {
      const inputPwd = Password.createPlain(command.password);
      const isMatch = await this.passwordService.verifyPassword(inputPwd, user.password);
      if (!isMatch) {
        await this.auditLogService.log(
          AuditAction.LOGIN_FAILED,
          command.ipAddress,
          command.userAgent,
          user.id,
          { reason: 'Password mismatch' },
        );
        throw new AuthenticationException('Invalid phone number or password');
      }
    }

    // 2. Check Account Status
    if (user.status === AccountStatus.BLOCKED || user.status === AccountStatus.SUSPENDED) {
      await this.auditLogService.log(
        AuditAction.LOGIN_FAILED,
        command.ipAddress,
        command.userAgent,
        user.id,
        { reason: `Account status is ${user.status}` },
      );
      throw new AuthorizationException(
        `Your account has been ${user.status.toLowerCase()}. Please contact support.`,
      );
    }

    // 3. Device Check & Fingerprint Validation
    const currentFingerprint = this.fingerprintService.generateFingerprint(
      command.platform,
      command.osVersion,
      command.appName,
      command.appVersion,
    );

    let device = await this.deviceRepo.findByUserIdAndFingerprint(
      user.id,
      currentFingerprint.hash,
    );

    // If New / Untrusted Device -> Require OTP challenge before issuing session tokens
    if (!device || !device.isTrusted) {
      const otp = Otp.create(user.phone.value);
      await this.otpRepo.save(otp);

      await this.auditLogService.log(
        AuditAction.OTP_GENERATED,
        command.ipAddress,
        command.userAgent,
        user.id,
        { reason: 'Untrusted device login challenge' },
      );

      return {
        user,
        requireOtpChallenge: true,
        challengeToken: otp.id,
      };
    }

    // 4. Update Device & Create Active Session
    device.updateLastLogin(command.ipAddress);
    await this.deviceRepo.save(device);

    const session = Session.create(
      user.id,
      device.id,
      command.ipAddress,
      command.userAgent,
      command.isRememberMe ?? false,
    );
    await this.sessionRepo.save(session);

    const tokens = this.jwtService.issueTokens(
      user.id,
      session.id.value,
      user.accountType,
      user.roles,
    );

    const refreshTokenEntity = RefreshTokenEntity.create(
      UuidUtil.generate(),
      tokens.jti,
      tokens.refreshToken,
      session.id.value,
      user.id,
      UuidUtil.generate(),
    );
    await this.refreshTokenRepo.save(refreshTokenEntity);

    await this.auditLogService.log(
      AuditAction.LOGIN_SUCCESS,
      command.ipAddress,
      command.userAgent,
      user.id,
      { sessionId: session.id.value, deviceId: device.id.value },
    );

    return { user, tokens, requireOtpChallenge: false };
  }
}
