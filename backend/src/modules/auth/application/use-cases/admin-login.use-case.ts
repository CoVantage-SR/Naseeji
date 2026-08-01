import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { IDeviceRepository } from '../../security/domain/repositories/device.repository.interface.js';
import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { PasswordService } from '../../security/services/password.service.js';
import { JwtService, IssuedTokens } from '../../security/services/jwt.service.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { Phone } from '../../identity/domain/value-objects/phone.vo.js';
import { Password } from '../../identity/domain/value-objects/password.vo.js';
import { AccountType } from '../../identity/domain/value-objects/account-type.enum.js';
import { Session } from '../../session/domain/entities/session.entity.js';
import { Device } from '../../security/domain/entities/device.entity.js';
import { RefreshTokenEntity } from '../../security/domain/entities/refresh-token.entity.js';
import { User } from '../../identity/domain/entities/user.entity.js';
import { AuthenticationException } from '@core/errors/auth.exception.js';
import { AuthorizationException } from '@core/errors/forbidden.exception.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface AdminLoginCommand {
  phone: string;
  password: string;
  ipAddress: string;
  userAgent: string;
}

export interface AdminLoginResponse {
  user: User;
  tokens: IssuedTokens;
}

export class AdminLoginUseCase {
  constructor(
    private userRepo: IUserRepository,
    private deviceRepo: IDeviceRepository,
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private passwordService: PasswordService,
    private jwtService: JwtService,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: AdminLoginCommand): Promise<AdminLoginResponse> {
    const phone = Phone.create(command.phone);
    const user = await this.userRepo.findByPhone(phone.value);

    if (!user || !user.password) {
      throw new AuthenticationException('Invalid admin credentials');
    }

    // Verify Admin / SuperAdmin account type or role
    const isAdmin =
      user.accountType === AccountType.ADMIN ||
      user.accountType === AccountType.SUPER_ADMIN ||
      user.roles.includes('ADMIN') ||
      user.roles.includes('SUPER_ADMIN');

    if (!isAdmin) {
      await this.auditLogService.log(
        AuditAction.LOGIN_FAILED,
        command.ipAddress,
        command.userAgent,
        user.id,
        { reason: 'Non-admin user attempted admin login' },
      );
      throw new AuthorizationException('Access denied: Admin credentials required');
    }

    const inputPwd = Password.createPlain(command.password);
    const isMatch = await this.passwordService.verifyPassword(inputPwd, user.password);
    if (!isMatch) {
      throw new AuthenticationException('Invalid admin credentials');
    }

    const device = Device.create(
      user.id,
      'WebDashboard',
      'AdminBrowser',
      'Web',
      'AdminPanel',
      '1.0.0',
      command.ipAddress,
    );
    await this.deviceRepo.save(device);

    const session = Session.create(user.id, device.id, command.ipAddress, command.userAgent, true);
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
      AuditAction.ADMIN_LOGIN,
      command.ipAddress,
      command.userAgent,
      user.id,
      { sessionId: session.id.value },
    );

    return { user, tokens };
  }
}
