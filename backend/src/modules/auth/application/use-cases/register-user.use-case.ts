import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { ICompanyRepository } from '../../../company/domain/repositories/company.repository.interface.js';
import { IDeviceRepository } from '../../security/domain/repositories/device.repository.interface.js';
import { ISessionRepository } from '../../session/domain/repositories/session.repository.interface.js';
import { IRefreshTokenRepository } from '../../security/domain/repositories/refresh-token.repository.interface.js';
import { PasswordService } from '../../security/services/password.service.js';
import { JwtService, IssuedTokens } from '../../security/services/jwt.service.js';
import { FingerprintService } from '../../security/services/fingerprint.service.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { User } from '../../identity/domain/entities/user.entity.js';
import { Company } from '../../../company/domain/entities/company.entity.js';
import { Device } from '../../security/domain/entities/device.entity.js';
import { Session } from '../../session/domain/entities/session.entity.js';
import { RefreshTokenEntity } from '../../security/domain/entities/refresh-token.entity.js';
import { Phone } from '../../identity/domain/value-objects/phone.vo.js';
import { Password } from '../../identity/domain/value-objects/password.vo.js';
import { AccountType } from '../../identity/domain/value-objects/account-type.enum.js';
import { CompanyReference } from '../../identity/domain/value-objects/company-reference.vo.js';
import { UserProfile } from '../../identity/domain/entities/user-profile.entity.js';
import { MongoTransactionManager } from '@database/mongo/transaction-manager.js';
import { BusinessException } from '@core/errors/business.exception.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface RegisterUserCommand {
  phone: string;
  password?: string;
  email?: string;
  accountType: AccountType;
  firstName: string;
  lastName: string;
  companyName: string;
  registrationNumber: string; // CR number / Tax ID
  platform: string;
  deviceName: string;
  osVersion: string;
  appName: string;
  appVersion: string;
  ipAddress: string;
  userAgent: string;
  pushToken?: string;
}

export interface RegisterUserResponse {
  user: User;
  company: Company;
  tokens: IssuedTokens;
}

export class RegisterUserUseCase {
  constructor(
    private userRepo: IUserRepository,
    private companyRepo: ICompanyRepository,
    private deviceRepo: IDeviceRepository,
    private sessionRepo: ISessionRepository,
    private refreshTokenRepo: IRefreshTokenRepository,
    private passwordService: PasswordService,
    private jwtService: JwtService,
    private fingerprintService: FingerprintService,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: RegisterUserCommand): Promise<RegisterUserResponse> {
    const phone = Phone.create(command.phone);

    // 1. Validate uniqueness
    const existingPhone = await this.userRepo.findByPhone(phone.value);
    if (existingPhone) {
      throw new BusinessException('Phone number is already registered');
    }

    if (command.email) {
      const existingEmail = await this.userRepo.findByEmail(command.email);
      if (existingEmail) {
        throw new BusinessException('Email is already registered');
      }
    }

    const existingCompany = await this.companyRepo.findByRegistrationNumber(
      command.registrationNumber,
    );
    if (existingCompany) {
      throw new BusinessException('Company registration number is already registered');
    }

    // 2. Hash password if provided
    let hashedPassword: Password | undefined;
    if (command.password) {
      const plainPassword = Password.createPlain(command.password);
      hashedPassword = await this.passwordService.hashPassword(plainPassword);
    }

    // 3. Prepare Entities
    const user = User.createNew(phone, command.accountType, command.email, hashedPassword);
    user.updateProfile(
      new UserProfile({
        firstName: command.firstName,
        lastName: command.lastName,
      }),
    );
    user.assignRole(
      command.accountType === AccountType.FACTORY ? 'FACTORY_ADMIN' : 'SUPPLIER_ADMIN',
    );

    const company = Company.create(
      command.companyName,
      command.accountType,
      command.registrationNumber,
      user.id,
    );
    user.activate(); // Activate user upon registration

    // 4. Bind company reference to user entity
    const companyRef = new CompanyReference(company.id, command.accountType);
    user.updateProfile(user.profile!);
    (user as unknown as { props: { companyReference: CompanyReference } }).props.companyReference = companyRef;

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

    const session = Session.create(user.id, device.id, command.ipAddress, command.userAgent, true);

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

    // 5. Execute Atomic MongoDB Transaction
    await MongoTransactionManager.runInTransaction(async (dbSession) => {
      await this.userRepo.save(user);
      await this.companyRepo.save(company, dbSession);
      await this.deviceRepo.save(device);
      await this.sessionRepo.save(session);
      await this.refreshTokenRepo.save(refreshTokenEntity);
    });

    // 6. Log Audit Trail
    await this.auditLogService.log(
      AuditAction.USER_REGISTERED,
      command.ipAddress,
      command.userAgent,
      user.id,
      {
        accountType: user.accountType,
        companyId: company.id,
        phone: user.phone.value,
      },
    );

    return { user, company, tokens };
  }
}
