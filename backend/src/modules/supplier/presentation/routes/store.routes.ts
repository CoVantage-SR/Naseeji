import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { requireRoles } from '@middleware/rbac.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import { createStoreSchema, updateStoreSchema } from '../../application/dtos/store.dto.js';

// Repositories
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { StoreRepository } from '../../infrastructure/repositories/store.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';

// Use Cases
import { CreateStoreUseCase } from '../../application/usecases/create-store.usecase.js';
import { UpdateStoreUseCase } from '../../application/usecases/update-store.usecase.js';
import { GetStoreUseCase } from '../../application/usecases/get-store.usecase.js';

// Controller
import { StoreController } from '../controllers/store.controller.js';

const supplierRepo = new SupplierRepository();
const storeRepo = new StoreRepository();
const securityLogRepo = new SecurityLogRepository();

const createStoreUseCase = new CreateStoreUseCase(supplierRepo, storeRepo, securityLogRepo);
const updateStoreUseCase = new UpdateStoreUseCase(supplierRepo, storeRepo, securityLogRepo);
const getStoreUseCase = new GetStoreUseCase(supplierRepo, storeRepo);

const storeController = new StoreController(
  createStoreUseCase,
  updateStoreUseCase,
  getStoreUseCase,
);

const router = Router();

// Public Store Details by Slug
router.get('/me', authenticateMiddleware, storeController.getSelfStore);
router.post(
  '/',
  authenticateMiddleware,
  requireRoles('supplier', 'ADMIN', 'admin'),
  validateRequest(createStoreSchema),
  storeController.createStore,
);
router.patch(
  '/me',
  authenticateMiddleware,
  requireRoles('supplier', 'ADMIN', 'admin'),
  validateRequest(updateStoreSchema),
  storeController.updateSelfStore,
);

router.get('/:slug', storeController.getPublicStoreBySlug);

export const storeRouter = router;
