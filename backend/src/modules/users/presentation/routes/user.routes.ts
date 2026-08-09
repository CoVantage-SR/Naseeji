import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { requireRoles } from '@middleware/rbac.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import { updateMeSchema } from '../../application/dtos/user.dto.js';
import { updateUserStatusSchema } from '../../application/dtos/admin-user.dto.js';

// Repositories & Services
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../../auth/infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../../auth/infrastructure/repositories/wallet.repository.js';
import { SessionRepository } from '../../../auth/infrastructure/repositories/session.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';

// Use Cases
import { GetMeUseCase } from '../../application/usecases/get-me.usecase.js';
import { UpdateMeUseCase } from '../../application/usecases/update-me.usecase.js';
import { AdminUserManagementUseCase } from '../../application/usecases/admin-user-management.usecase.js';

// Controller
import { UserController } from '../controllers/user.controller.js';

const userRepo = new UserRepository();
const factoryRepo = new FactoryRepository();
const supplierRepo = new SupplierRepository();
const walletRepo = new WalletRepository();
const sessionRepo = new SessionRepository();
const securityLogRepo = new SecurityLogRepository();

const getMeUseCase = new GetMeUseCase(userRepo, factoryRepo, supplierRepo, walletRepo);
const updateMeUseCase = new UpdateMeUseCase(
  userRepo,
  factoryRepo,
  supplierRepo,
  securityLogRepo,
  getMeUseCase,
);
const adminUserManagementUseCase = new AdminUserManagementUseCase(
  userRepo,
  factoryRepo,
  supplierRepo,
  sessionRepo,
  securityLogRepo,
);

const controller = new UserController(getMeUseCase, updateMeUseCase, adminUserManagementUseCase);

const router = Router();

router.use(authenticateMiddleware);

// Authenticated user self profile management
router.get('/me', controller.getMe);
router.patch('/me', validateRequest(updateMeSchema), controller.updateMe);

// Admin-only user management endpoints
router.get('/', requireRoles('admin', 'support', 'auditor'), controller.listUsers);
router.get('/:id', requireRoles('admin', 'support', 'auditor'), controller.getUserById);
router.patch(
  '/:id/status',
  requireRoles('admin', 'support'),
  validateRequest(updateUserStatusSchema),
  controller.updateUserStatus,
);

export const userRouter = router;
