import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { requireRoles } from '@middleware/rbac.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import {
  updateSupplierProfileSchema,
  submitVerificationSchema,
  adminUpdateVerificationSchema,
  adminSupplierStatusSchema,
} from '../../application/dtos/supplier.dto.js';
import { createStoreSchema, updateStoreSchema } from '../../application/dtos/store.dto.js';

// Repositories
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { VerificationRequestRepository } from '../../../auth/infrastructure/repositories/verification-request.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../../auth/infrastructure/repositories/session.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { StoreRepository } from '../../infrastructure/repositories/store.repository.js';

// Use Cases
import { GetSupplierProfileUseCase } from '../../application/usecases/get-supplier-profile.usecase.js';
import { UpdateSupplierProfileUseCase } from '../../application/usecases/update-supplier-profile.usecase.js';
import { ListSuppliersUseCase } from '../../application/usecases/list-suppliers.usecase.js';
import { SubmitSupplierVerificationUseCase } from '../../application/usecases/submit-supplier-verification.usecase.js';
import { AdminSupplierManagementUseCase } from '../../application/usecases/admin-supplier-management.usecase.js';
import { CreateStoreUseCase } from '../../application/usecases/create-store.usecase.js';
import { UpdateStoreUseCase } from '../../application/usecases/update-store.usecase.js';
import { GetStoreUseCase } from '../../application/usecases/get-store.usecase.js';

// Controllers
import { SupplierController } from '../controllers/supplier.controller.js';
import { StoreController } from '../controllers/store.controller.js';

const supplierRepo = new SupplierRepository();
const verificationRepo = new VerificationRequestRepository();
const userRepo = new UserRepository();
const sessionRepo = new SessionRepository();
const securityLogRepo = new SecurityLogRepository();
const storeRepo = new StoreRepository();

const getSupplierProfileUseCase = new GetSupplierProfileUseCase(supplierRepo);
const updateSupplierProfileUseCase = new UpdateSupplierProfileUseCase(
  supplierRepo,
  securityLogRepo,
  getSupplierProfileUseCase,
);
const listSuppliersUseCase = new ListSuppliersUseCase(supplierRepo, getSupplierProfileUseCase);
const submitSupplierVerificationUseCase = new SubmitSupplierVerificationUseCase(
  supplierRepo,
  verificationRepo,
  securityLogRepo,
);
const adminSupplierManagementUseCase = new AdminSupplierManagementUseCase(
  supplierRepo,
  verificationRepo,
  userRepo,
  sessionRepo,
  storeRepo,
  securityLogRepo,
);

const createStoreUseCase = new CreateStoreUseCase(supplierRepo, storeRepo, securityLogRepo);
const updateStoreUseCase = new UpdateStoreUseCase(supplierRepo, storeRepo, securityLogRepo);
const getStoreUseCase = new GetStoreUseCase(supplierRepo, storeRepo);

const supplierController = new SupplierController(
  getSupplierProfileUseCase,
  updateSupplierProfileUseCase,
  listSuppliersUseCase,
  submitSupplierVerificationUseCase,
  adminSupplierManagementUseCase,
);

const storeController = new StoreController(
  createStoreUseCase,
  updateStoreUseCase,
  getStoreUseCase,
);

const router = Router();

// Public Supplier Directory & Public Supplier Profile Routes
router.get('/', supplierController.listSuppliers);

// Authenticated Supplier Self Management Routes
router.get('/me', authenticateMiddleware, supplierController.getSelfProfile);
router.patch(
  '/me',
  authenticateMiddleware,
  requireRoles('supplier', 'ADMIN', 'admin'),
  validateRequest(updateSupplierProfileSchema),
  supplierController.updateSelfProfile,
);
router.post(
  '/me/verification',
  authenticateMiddleware,
  requireRoles('supplier', 'ADMIN', 'admin'),
  validateRequest(submitVerificationSchema),
  supplierController.submitVerification,
);

// Authenticated Supplier Store Management Routes (/api/v1/suppliers/me/store)
router.post(
  '/me/store',
  authenticateMiddleware,
  requireRoles('supplier', 'ADMIN', 'admin'),
  validateRequest(createStoreSchema),
  storeController.createStore,
);
router.get('/me/store', authenticateMiddleware, storeController.getSelfStore);
router.patch(
  '/me/store',
  authenticateMiddleware,
  requireRoles('supplier', 'ADMIN', 'admin'),
  validateRequest(updateStoreSchema),
  storeController.updateSelfStore,
);

// Admin Supplier & Verification Management Routes
router.patch(
  '/admin/verifications/:requestId',
  authenticateMiddleware,
  requireRoles('admin', 'support'),
  validateRequest(adminUpdateVerificationSchema),
  supplierController.adminReviewVerification,
);
router.patch(
  '/admin/:id/status',
  authenticateMiddleware,
  requireRoles('admin'),
  validateRequest(adminSupplierStatusSchema),
  supplierController.adminSetSupplierActiveStatus,
);

// Public Single Supplier Details Route (by ID or Slug)
router.get('/:idOrSlug', supplierController.getPublicProfile);

export const supplierRouter = router;
