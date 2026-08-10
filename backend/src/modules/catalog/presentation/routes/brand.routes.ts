import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { authorize } from '@middleware/authorize.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import { createBrandSchema, updateBrandSchema } from '../../application/dtos/brand.dto.js';

import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';

import { CreateBrandUseCase } from '../../application/usecases/create-brand.usecase.js';
import { UpdateBrandUseCase } from '../../application/usecases/update-brand.usecase.js';
import { DeleteBrandUseCase } from '../../application/usecases/delete-brand.usecase.js';
import { GetBrandUseCase } from '../../application/usecases/get-brand.usecase.js';
import { ListBrandsUseCase } from '../../application/usecases/list-brands.usecase.js';

import { BrandController } from '../controllers/brand.controller.js';

const brandRepo = new BrandRepository();
const securityLogRepo = new SecurityLogRepository();

const createBrandUseCase = new CreateBrandUseCase(brandRepo, securityLogRepo);
const updateBrandUseCase = new UpdateBrandUseCase(brandRepo, securityLogRepo);
const deleteBrandUseCase = new DeleteBrandUseCase(brandRepo, securityLogRepo);
const getBrandUseCase = new GetBrandUseCase(brandRepo);
const listBrandsUseCase = new ListBrandsUseCase(brandRepo);

const brandController = new BrandController(
  createBrandUseCase,
  updateBrandUseCase,
  deleteBrandUseCase,
  getBrandUseCase,
  listBrandsUseCase,
);

const router = Router();

// Public routes
router.get('/slug/:slug', brandController.getBrandBySlug);
router.get('/:id', brandController.getBrandById);
router.get('/', brandController.listBrands);

// Management routes
router.post(
  '/',
  authenticateMiddleware,
  authorize('brands.create'),
  validateRequest(createBrandSchema),
  brandController.createBrand,
);

router.patch(
  '/:id',
  authenticateMiddleware,
  authorize('brands.update'),
  validateRequest(updateBrandSchema),
  brandController.updateBrand,
);

router.delete(
  '/:id',
  authenticateMiddleware,
  authorize('brands.delete'),
  brandController.deleteBrand,
);

export const brandRouter = router;
