import { Router } from 'express';
import { AuthController } from '../controllers/auth.controller.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { registerUserSchema } from '../validators/register.validator.js';
import { loginSchema, verifyDeviceLoginSchema } from '../validators/login.validator.js';
import { generateOtpSchema, verifyOtpSchema } from '../validators/otp.validator.js';
import { forgotPasswordSchema, resetPasswordSchema } from '../validators/password.validator.js';

// Repositories & Services dependencies instantiation
import { MongoUserRepository } from '../../identity/data/repositories/mongo-user.repository.js';
import { MongoCompanyRepository } from '../../../company/data/repositories/mongo-company.repository.js';
import { MongoDeviceRepository } from '../../security/data/repositories/mongo-device.repository.js';
import { MongoSessionRepository } from '../../session/data/repositories/mongo-session.repository.js';
import { MongoRefreshTokenRepository } from '../../security/data/repositories/mongo-refresh-token.repository.js';
import { MongoOtpRepository } from '../../otp/data/repositories/mongo-otp.repository.js';
import { MongoAuditLogRepository } from '../../../audit/data/repositories/mongo-audit-log.repository.js';
import { PasswordService } from '../../security/services/password.service.js';
import { JwtService } from '../../security/services/jwt.service.js';
import { FingerprintService } from '../../security/services/fingerprint.service.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';

// Use cases instantiation
import { RegisterUserUseCase } from '../../application/use-cases/register-user.use-case.js';
import { LoginUseCase } from '../../application/use-cases/login.use-case.js';
import { VerifyDeviceLoginUseCase } from '../../application/use-cases/verify-device-login.use-case.js';
import { GenerateOtpUseCase } from '../../otp/application/use-cases/generate-otp.use-case.js';
import { VerifyOtpUseCase } from '../../otp/application/use-cases/verify-otp.use-case.js';
import { ForgotPasswordUseCase } from '../../application/use-cases/forgot-password.use-case.js';
import { ResetPasswordUseCase } from '../../application/use-cases/reset-password.use-case.js';
import { IssueRefreshTokenUseCase } from '../../security/application/use-cases/issue-refresh-token.use-case.js';
import { LogoutUseCase } from '../../application/use-cases/logout.use-case.js';
import { LogoutAllDevicesUseCase } from '../../application/use-cases/logout-all-devices.use-case.js';

const router = Router();

const userRepo = new MongoUserRepository();
const companyRepo = new MongoCompanyRepository();
const deviceRepo = new MongoDeviceRepository();
const sessionRepo = new MongoSessionRepository();
const refreshTokenRepo = new MongoRefreshTokenRepository();
const otpRepo = new MongoOtpRepository();
const auditLogRepo = new MongoAuditLogRepository();

const passwordService = new PasswordService();
const jwtService = new JwtService();
const fingerprintService = new FingerprintService();
const auditLogService = new AuditLogService(auditLogRepo);

const registerUserUseCase = new RegisterUserUseCase(
  userRepo,
  companyRepo,
  deviceRepo,
  sessionRepo,
  refreshTokenRepo,
  passwordService,
  jwtService,
  auditLogService,
);
const loginUseCase = new LoginUseCase(
  userRepo,
  deviceRepo,
  sessionRepo,
  refreshTokenRepo,
  otpRepo,
  passwordService,
  jwtService,
  fingerprintService,
  auditLogService,
);
const verifyDeviceLoginUseCase = new VerifyDeviceLoginUseCase(
  userRepo,
  deviceRepo,
  sessionRepo,
  refreshTokenRepo,
  otpRepo,
  jwtService,
  auditLogService,
);
const generateOtpUseCase = new GenerateOtpUseCase(otpRepo);
const verifyOtpUseCase = new VerifyOtpUseCase(otpRepo);
const forgotPasswordUseCase = new ForgotPasswordUseCase(userRepo, otpRepo, auditLogService);
const resetPasswordUseCase = new ResetPasswordUseCase(
  userRepo,
  otpRepo,
  sessionRepo,
  refreshTokenRepo,
  passwordService,
  auditLogService,
);
const issueRefreshTokenUseCase = new IssueRefreshTokenUseCase(jwtService, refreshTokenRepo);
const logoutUseCase = new LogoutUseCase(sessionRepo, refreshTokenRepo, auditLogService);
const logoutAllDevicesUseCase = new LogoutAllDevicesUseCase(
  sessionRepo,
  refreshTokenRepo,
  auditLogService,
);

const controller = new AuthController(
  registerUserUseCase,
  loginUseCase,
  verifyDeviceLoginUseCase,
  generateOtpUseCase,
  verifyOtpUseCase,
  forgotPasswordUseCase,
  resetPasswordUseCase,
  issueRefreshTokenUseCase,
  logoutUseCase,
  logoutAllDevicesUseCase,
);

router.post('/register', validateRequest(registerUserSchema), controller.register);
router.post('/login', validateRequest(loginSchema), controller.login);
router.post(
  '/verify-device-login',
  validateRequest(verifyDeviceLoginSchema),
  controller.verifyDeviceLogin,
);
router.post('/otp/generate', validateRequest(generateOtpSchema), controller.generateOtp);
router.post('/otp/verify', validateRequest(verifyOtpSchema), controller.verifyOtp);
router.post('/forgot-password', validateRequest(forgotPasswordSchema), controller.forgotPassword);
router.post('/reset-password', validateRequest(resetPasswordSchema), controller.resetPassword);
router.post('/refresh-token', controller.refreshToken);

router.post('/logout', authenticateMiddleware, controller.logout);
router.post('/logout-all', authenticateMiddleware, controller.logoutAll);

export const authRouter = router;
