import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { authorize } from '@middleware/authorize.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import {
  createCategorySchema,
  updateCategorySchema,
} from '../../application/dtos/category.dto.js';

import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';

import { CreateCategoryUseCase } from '../../application/usecases/create-category.usecase.js';
import { UpdateCategoryUseCase } from '../../application/usecases/update-category.usecase.js';
import { DeleteCategoryUseCase } from '../../application/usecases/delete-category.usecase.js';
import { GetCategoryUseCase } from '../../application/usecases/get-category.usecase.js';
import { ListCategoriesUseCase } from '../../application/usecases/list-categories.usecase.js';

import { CategoryController } from '../controllers/category.controller.js';

const categoryRepo = new CategoryRepository();
const securityLogRepo = new SecurityLogRepository();

const createCategoryUseCase = new CreateCategoryUseCase(categoryRepo, securityLogRepo);
const updateCategoryUseCase = new UpdateCategoryUseCase(categoryRepo, securityLogRepo);
const deleteCategoryUseCase = new DeleteCategoryUseCase(categoryRepo, securityLogRepo);
const getCategoryUseCase = new GetCategoryUseCase(categoryRepo);
const listCategoriesUseCase = new ListCategoriesUseCase(categoryRepo);

const categoryController = new CategoryController(
  createCategoryUseCase,
  updateCategoryUseCase,
  deleteCategoryUseCase,
  getCategoryUseCase,
  listCategoriesUseCase,
);

const router = Router();

// Public routes
router.get('/tree', categoryController.getCategoryTree);
router.get('/slug/:slug', categoryController.getCategoryBySlug);
router.get('/:id', categoryController.getCategoryById);
router.get('/', categoryController.listCategories);

// Admin / Management routes
router.post(
  '/',
  authenticateMiddleware,
  authorize('categories.create'),
  validateRequest(createCategorySchema),
  categoryController.createCategory,
);

router.patch(
  '/:id',
  authenticateMiddleware,
  authorize('categories.update'),
  validateRequest(updateCategorySchema),
  categoryController.updateCategory,
);

router.delete(
  '/:id',
  authenticateMiddleware,
  authorize('categories.delete'),
  categoryController.deleteCategory,
);

export const categoryRouter = router;
