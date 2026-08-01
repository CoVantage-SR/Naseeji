// Domain Errors
export * from './domain/errors/auth-domain.exceptions.js';

// Identity Domain & Data
export * from './identity/domain/value-objects/account-status.enum.js';
export * from './identity/domain/value-objects/account-type.enum.js';
export * from './identity/domain/value-objects/phone.vo.js';
export * from './identity/domain/value-objects/password.vo.js';
export * from './identity/domain/value-objects/company-reference.vo.js';
export * from './identity/domain/entities/user-profile.entity.js';
export * from './identity/domain/entities/user.entity.js';
export * from './identity/domain/repositories/user.repository.interface.js';
export * from './identity/data/models/user.model.js';
export * from './identity/data/mappers/user.mapper.js';
export * from './identity/data/repositories/mongo-user.repository.js';

// Session Domain & Data
export * from './session/domain/value-objects/session-id.vo.js';
export * from './session/domain/entities/session.entity.js';
export * from './session/domain/repositories/session.repository.interface.js';
export * from './session/data/models/session.model.js';
export * from './session/data/mappers/session.mapper.js';
export * from './session/data/repositories/mongo-session.repository.js';
export * from './session/application/use-cases/create-session.use-case.js';

// Security Domain, Data & Services
export * from './security/domain/value-objects/device-id.vo.js';
export * from './security/domain/value-objects/device-fingerprint.vo.js';
export * from './security/domain/value-objects/refresh-token.vo.js';
export * from './security/domain/entities/device.entity.js';
export * from './security/domain/entities/refresh-token.entity.js';
export * from './security/domain/repositories/device.repository.interface.js';
export * from './security/domain/repositories/refresh-token.repository.interface.js';
export * from './security/data/models/device.model.ts';
export * from './security/data/models/refresh-token.model.ts';
export * from './security/data/mappers/device.mapper.js';
export * from './security/data/mappers/refresh-token.mapper.js';
export * from './security/data/repositories/mongo-device.repository.js';
export * from './security/data/repositories/mongo-refresh-token.repository.js';
export * from './security/services/jwt.service.js';
export * from './security/services/password.service.js';
export * from './security/services/fingerprint.service.js';
export * from './security/application/use-cases/create-device.use-case.js';
export * from './security/application/use-cases/issue-access-token.use-case.js';
export * from './security/application/use-cases/issue-refresh-token.use-case.js';

// OTP Domain, Data & Use Cases
export * from './otp/domain/value-objects/otp-code.vo.js';
export * from './otp/domain/entities/otp.entity.js';
export * from './otp/domain/repositories/otp.repository.interface.js';
export * from './otp/data/models/otp.model.js';
export * from './otp/data/mappers/otp.mapper.js';
export * from './otp/data/repositories/mongo-otp.repository.js';
export * from './otp/providers/otp-provider.interface.js';
export * from './otp/application/use-cases/generate-otp.use-case.js';
export * from './otp/application/use-cases/verify-otp.use-case.js';

// Authorization Domain, Data & Services
export * from './authorization/domain/value-objects/role-id.vo.js';
export * from './authorization/domain/value-objects/permission-id.vo.js';
export * from './authorization/domain/entities/permission.entity.js';
export * from './authorization/domain/entities/role.entity.js';
export * from './authorization/domain/repositories/permission.repository.interface.js';
export * from './authorization/domain/repositories/role.repository.interface.js';
export * from './authorization/data/models/permission.model.js';
export * from './authorization/data/models/role.model.js';
export * from './authorization/data/mappers/permission.mapper.js';
export * from './authorization/data/mappers/role.mapper.js';
export * from './authorization/data/repositories/mongo-permission.repository.js';
export * from './authorization/data/repositories/mongo-role.repository.js';
export * from './authorization/services/permission-resolver.service.js';
export * from './authorization/services/permission-checker.service.js';
export * from './authorization/application/use-cases/assign-role.use-case.js';
