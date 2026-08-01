import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { IDeviceRepository } from '../../security/domain/repositories/device.repository.interface.js';
import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { IOtpRepository } from '../../otp/domain/repositories/otp.repository.interface.js';
import { JwtService, IssuedTokens } from '../../security/services/jwt.service.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { Session } from '../../session/domain/entities/session.entity.js';
import { Device } from '../../security/domain/entities/device.entity.js';
import { RefreshTokenEntity } from '../../security/domain/entities/refresh-token.entity.js';
import { User } from '../../identity/domain/entities/user.entity.js';
import { OtpInvalidException } from '../../domain/errors/auth-domain.exceptions.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface VerifyDeviceLoginCommand {
  phone: string;
  otpCode: string;
  platform: string;
  deviceName: string;
  osVersion: string;
  appName: string;
  appVersion: string;
  ipAddress: string;
  userAgent: string;
  pushToken?: string;
  isRememberMe?: boolean;
}

export interface VerifyDeviceLoginResponse {
  user: User;
  tokens: IssuedTokens;
}

export class VerifyDeviceLoginUseCase {
  constructor(
    private userRepo: IUserRepository,
    private deviceRepo: IDeviceRepository,
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private otpRepo: IOtpRepository,
    private jwtService: JwtService,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: VerifyDeviceLoginCommand): Promise<VerifyDeviceLoginResponse> {
    const user = await this.userRepo.findByPhone(command.phone);
    if (!user) {
      throw new OtpInvalidException('User not found');
    }

    const latestOtp = await this.otpRepo.findLatestByPhone(command.phone);
    if (!latestOtp) {
      throw new OtpInvalidException('No active OTP challenge found');
    }

    latestOtp.verify(command.otpCode);
    await this.otpRepo.save(latestOtp);

    // Register / trust device
    const device = Device.create(
      user.id,
      command.platform,
      command.deviceName,
      command.osVersion,
      command.appName,
      command.appVersion,
      command.ipAddress,
      command.pushToken,
    );
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
      AuditAction.DEVICE_REGISTERED,
      command.ipAddress,
      command.userAgent,
      user.id,
      { deviceId: device.id.value, platform: command.platform },
    );

    return { user, tokens };
  }
}
