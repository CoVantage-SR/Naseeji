import { Router } from 'express';
import { AdminAuthController } from '../controllers/admin-auth.controller.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { authorize } from '@middleware/authorize.middleware.js';
import { loginSchema } from '../validators/login.validator.js';

// Repositories & Services dependencies instantiation
import { MongoUserRepository } from '../../identity/data/repositories/mongo-user.repository.js';
import { MongoDeviceRepository } from '../../security/data/repositories/mongo-device.repository.js';
import { MongoSessionRepository } from '../../session/data/repositories/mongo-session.repository.js';
import { MongoRefreshTokenRepository } from '../../security/data/repositories/mongo-refresh-token.repository.js';
import { MongoAuditLogRepository } from '../../../audit/data/repositories/mongo-audit-log.repository.js';
import { PasswordService } from '../../security/services/password.service.js';
import { JwtService } from '../../security/services/jwt.service.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';

// Use cases instantiation
import { AdminLoginUseCase } from '../../application/use-cases/admin-login.use-case.js';
import { ForceLogoutUserUseCase } from '../../application/use-cases/force-logout-user.use-case.js';
import { BlockUserUseCase } from '../../application/use-cases/block-user.use-case.js';
import { SuspendUserUseCase } from '../../application/use-cases/suspend-user.use-case.js';
import { ActivateUserUseCase } from '../../application/use-cases/activate-user.use-case.js';
import { AdminResetPasswordUseCase } from '../../application/use-cases/admin-reset-password.use-case.js';
import { GetAuditLogsUseCase } from '../../application/use-cases/get-audit-logs.use-case.js';

const router = Router();

const userRepo = new MongoUserRepository();
const deviceRepo = new MongoDeviceRepository();
const sessionRepo = new MongoSessionRepository();
const refreshTokenRepo = new MongoRefreshTokenRepository();
const auditLogRepo = new MongoAuditLogRepository();

const passwordService = new PasswordService();
const jwtService = new JwtService();
const auditLogService = new AuditLogService(auditLogRepo);

const adminLoginUseCase = new AdminLoginUseCase(
  userRepo,
  deviceRepo,
  sessionRepo,
  refreshTokenRepo,
  passwordService,
  jwtService,
  auditLogService,
);
const forceLogoutUserUseCase = new ForceLogoutUserUseCase(
  sessionRepo,
  refreshTokenRepo,
  auditLogService,
);
const blockUserUseCase = new BlockUserUseCase(
  userRepo,
  sessionRepo,
  refreshTokenRepo,
  auditLogService,
);
const suspendUserUseCase = new SuspendUserUseCase(
  userRepo,
  sessionRepo,
  refreshTokenRepo,
  auditLogService,
);
const activateUserUseCase = new ActivateUserUseCase(userRepo, auditLogService);
const adminResetPasswordUseCase = new AdminResetPasswordUseCase(
  userRepo,
  sessionRepo,
  refreshTokenRepo,
  passwordService,
  auditLogService,
);
const getAuditLogsUseCase = new GetAuditLogsUseCase(auditLogRepo);

const controller = new AdminAuthController(
  adminLoginUseCase,
  forceLogoutUserUseCase,
  blockUserUseCase,
  suspendUserUseCase,
  activateUserUseCase,
  adminResetPasswordUseCase,
  getAuditLogsUseCase,
);

router.post('/login', validateRequest(loginSchema), controller.login);

router.use(authenticateMiddleware);

router.post('/sessions/force-logout', authorize('session:force_logout'), controller.forceLogout);

router.patch('/users/:id/block', authorize('user:manage_status'), controller.blockUser);
router.patch('/users/:id/suspend', authorize('user:manage_status'), controller.suspendUser);
router.patch('/users/:id/activate', authorize('user:manage_status'), controller.activateUser);
router.post(
  '/users/:id/reset-password',
  authorize('user:reset_password'),
  controller.resetUserPassword,
);
router.get('/audit-logs', authorize('audit:view'), controller.getAuditLogs);

export const adminAuthRouter = router;
