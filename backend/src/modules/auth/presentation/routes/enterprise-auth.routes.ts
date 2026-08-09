import { Router } from 'express';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { requireRoles } from '@middleware/rbac.middleware.js';
import {
  registerFactorySchema,
  registerSupplierSchema,
  loginSchema,
  refreshTokenSchema,
  forgotPasswordSchema,
  resetPasswordSchema,
  changePasswordSchema,
  updateVerificationStatusSchema,
} from '../validators/auth.validators.js';

// Repositories
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { VerificationRequestRepository } from '../../infrastructure/repositories/verification-request.repository.js';
import { OtpRepository } from '../../infrastructure/repositories/otp.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';
import { DeviceRepository } from '../../infrastructure/repositories/device.repository.js';

// Services & Use Cases
import { GoogleOAuthService } from '../../application/services/google-auth.service.js';
import { RegisterFactoryUseCase } from '../../application/usecases/register-factory.usecase.js';
import { RegisterSupplierUseCase } from '../../application/usecases/register-supplier.usecase.js';
import { LoginUseCase } from '../../application/usecases/login.usecase.js';
import { LogoutUseCase } from '../../application/usecases/logout.usecase.js';
import { RefreshTokenUseCase } from '../../application/usecases/refresh-token.usecase.js';
import {
  ForgotPasswordUseCase,
  ResetPasswordUseCase,
} from '../../application/usecases/forgot-password.usecase.js';
import { ChangePasswordUseCase } from '../../application/usecases/change-password.usecase.js';
import { VerifyEmailPhoneUseCase } from '../../application/usecases/verify-email-phone.usecase.js';
import { SessionManagementUseCase } from '../../application/usecases/session-management.usecase.js';
import { AccountLifecycleUseCase } from '../../application/usecases/account-lifecycle.usecase.js';
import { SupplierVerificationUseCase } from '../../application/usecases/supplier-verification.usecase.js';
import { GoogleLoginUseCase } from '../../application/usecases/google-login.usecase.js';
import { DeviceManagementUseCase } from '../../application/usecases/device-management.usecase.js';

// Controllers
import { EnterpriseAuthController } from '../controllers/enterprise-auth.controller.js';
import { VerificationController } from '../controllers/verification.controller.js';

const jwtSecret = process.env.JWT_SECRET || 'naseeji-enterprise-super-secret-jwt-key-2026';

// Instantiate Repositories & Services
const userRepo = new UserRepository();
const factoryRepo = new FactoryRepository();
const supplierRepo = new SupplierRepository();
const walletRepo = new WalletRepository();
const sessionRepo = new SessionRepository();
const refreshTokenRepo = new RefreshTokenRepository();
const verificationRepo = new VerificationRequestRepository();
const otpRepo = new OtpRepository();
const securityLogRepo = new SecurityLogRepository();
const deviceRepo = new DeviceRepository();
const googleAuthService = new GoogleOAuthService();

// Instantiate Use Cases
const registerFactoryUseCase = new RegisterFactoryUseCase(
  userRepo,
  factoryRepo,
  walletRepo,
  verificationRepo,
  securityLogRepo,
  otpRepo, // inject OtpRepository for post-registration OTP dispatch
);
const registerSupplierUseCase = new RegisterSupplierUseCase(
  userRepo,
  supplierRepo,
  walletRepo,
  verificationRepo,
  securityLogRepo,
  otpRepo, // inject OtpRepository for post-registration OTP dispatch
);
const loginUseCase = new LoginUseCase(
  userRepo,
  factoryRepo,
  supplierRepo,
  walletRepo,
  sessionRepo,
  refreshTokenRepo,
  securityLogRepo,
  jwtSecret,
);
const logoutUseCase = new LogoutUseCase(sessionRepo, refreshTokenRepo, securityLogRepo);
const refreshTokenUseCase = new RefreshTokenUseCase(
  userRepo,
  sessionRepo,
  refreshTokenRepo,
  securityLogRepo,
  jwtSecret,
);
const forgotPasswordUseCase = new ForgotPasswordUseCase(userRepo, otpRepo, securityLogRepo);
const resetPasswordUseCase = new ResetPasswordUseCase(userRepo, otpRepo, securityLogRepo);
const changePasswordUseCase = new ChangePasswordUseCase(
  userRepo,
  sessionRepo,
  refreshTokenRepo,
  securityLogRepo,
);
const verifyEmailPhoneUseCase = new VerifyEmailPhoneUseCase(userRepo, otpRepo, securityLogRepo);
const sessionManagementUseCase = new SessionManagementUseCase(
  sessionRepo,
  refreshTokenRepo,
  securityLogRepo,
);
const accountLifecycleUseCase = new AccountLifecycleUseCase(
  userRepo,
  sessionRepo,
  refreshTokenRepo,
  securityLogRepo,
);
const supplierVerificationUseCase = new SupplierVerificationUseCase(
  verificationRepo,
  supplierRepo,
  factoryRepo,
  userRepo,
  securityLogRepo,
);

const googleLoginUseCase = new GoogleLoginUseCase(
  googleAuthService,
  userRepo,
  factoryRepo,
  supplierRepo,
  walletRepo,
  deviceRepo,
  sessionRepo,
  refreshTokenRepo,
  securityLogRepo,
  jwtSecret,
);

const deviceManagementUseCase = new DeviceManagementUseCase(
  deviceRepo,
  userRepo,
  factoryRepo,
  supplierRepo,
  walletRepo,
  securityLogRepo,
);

// Instantiate Controllers
const authController = new EnterpriseAuthController(
  registerFactoryUseCase,
  registerSupplierUseCase,
  loginUseCase,
  logoutUseCase,
  refreshTokenUseCase,
  forgotPasswordUseCase,
  resetPasswordUseCase,
  changePasswordUseCase,
  verifyEmailPhoneUseCase,
  sessionManagementUseCase,
  accountLifecycleUseCase,
  googleLoginUseCase,
  deviceManagementUseCase,
  userRepo,
  factoryRepo,
  supplierRepo,
  securityLogRepo,
);

const verificationController = new VerificationController(supplierVerificationUseCase);

const router = Router();

// Public Authentication Routes
router.post(
  '/register/factory',
  validateRequest(registerFactorySchema),
  authController.registerFactory,
);
router.post(
  '/register/supplier',
  validateRequest(registerSupplierSchema),
  authController.registerSupplier,
);
router.post('/login', validateRequest(loginSchema), authController.login);
router.post('/google', authController.loginGoogle);
router.post('/send-otp', authController.sendWhatsAppOtp);
router.post('/verify-otp', authController.verifyWhatsAppOtp);

// Refresh Token Route & Alias
router.post('/refresh', validateRequest(refreshTokenSchema), authController.refreshToken);
router.post('/refresh-token', validateRequest(refreshTokenSchema), authController.refreshToken);

router.post(
  '/forgot-password',
  validateRequest(forgotPasswordSchema),
  authController.forgotPassword,
);
router.post('/reset-password', validateRequest(resetPasswordSchema), authController.resetPassword);
router.post('/resend-otp', authController.resendOtp);

// Authenticated User Routes & Aliases
router.use(authenticateMiddleware);
router.get('/me', authController.getMe);
router.get('/profile', authController.getMe);
router.patch('/profile', authController.updateProfile);
router.post('/logout', authController.logout);
router.post('/logout-all', authController.revokeAllSessions);
router.post(
  '/change-password',
  validateRequest(changePasswordSchema),
  authController.changePassword,
);
router.post('/verify-phone', authController.verifyPhone);
router.post('/verify-email', authController.verifyEmail);
router.post('/deactivate', authController.deactivate);
router.delete('/account', authController.softDelete);

// Device & Active Session Management Routes
router.get('/devices', authController.getDevices);
router.delete('/device/:id', authController.deleteDevice);
router.get('/sessions', authController.getSessions);
router.delete('/sessions/:sessionId', authController.revokeSession);
router.delete('/sessions', authController.revokeAllSessions);

// Audit Security Logs
router.get('/security-logs', authController.getSecurityLogs);

// Admin & Support Verification Management Routes
router.get(
  '/verification/requests',
  requireRoles('admin', 'support', 'auditor'),
  verificationController.getPendingRequests,
);
router.patch(
  '/verification/:requestId',
  requireRoles('admin', 'support'),
  validateRequest(updateVerificationStatusSchema),
  verificationController.updateStatus,
);

export const enterpriseAuthRouter = router;
