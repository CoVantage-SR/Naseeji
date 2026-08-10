import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { authorize } from '@middleware/authorize.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import { adminUpdateProductStatusSchema } from '../../application/dtos/product.dto.js';

import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { StoreRepository } from '../../../supplier/infrastructure/repositories/store.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';

import { AdminProductManagementUseCase } from '../../application/usecases/admin-product-management.usecase.js';
import { GetProductUseCase } from '../../application/usecases/get-product.usecase.js';

import { AdminCatalogController } from '../controllers/admin-catalog.controller.js';

const productRepo = new ProductRepository();
const categoryRepo = new CategoryRepository();
const brandRepo = new BrandRepository();
const mediaRepo = new ProductMediaRepository();
const supplierRepo = new SupplierRepository();
const storeRepo = new StoreRepository();
const securityLogRepo = new SecurityLogRepository();

const adminProductUseCase = new AdminProductManagementUseCase(productRepo, securityLogRepo);
const getProductUseCase = new GetProductUseCase(
  productRepo,
  categoryRepo,
  brandRepo,
  mediaRepo,
  supplierRepo,
  storeRepo,
);

const adminCatalogController = new AdminCatalogController(adminProductUseCase, getProductUseCase);

import {
  CreateCategoryUseCase,
  UpdateCategoryUseCase,
  DeleteCategoryUseCase,
  GetCategoryUseCase,
  ListCategoriesUseCase,
} from '../../application/usecases/index.js';
import { CategoryController } from '../controllers/category.controller.js';

import {
  CreateBrandUseCase,
  UpdateBrandUseCase,
  DeleteBrandUseCase,
  GetBrandUseCase,
  ListBrandsUseCase,
} from '../../application/usecases/index.js';
import { BrandController } from '../controllers/brand.controller.js';

import { createCategorySchema, updateCategorySchema } from '../../application/dtos/category.dto.js';
import { createBrandSchema, updateBrandSchema } from '../../application/dtos/brand.dto.js';

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

// Admin Products
router.get(
  '/products',
  authenticateMiddleware,
  authorize('products.approve'),
  adminCatalogController.listProducts,
);

router.get(
  '/products/:id',
  authenticateMiddleware,
  authorize('products.approve'),
  adminCatalogController.getProductById,
);

router.patch(
  '/products/:id/status',
  authenticateMiddleware,
  authorize('products.approve'),
  validateRequest(adminUpdateProductStatusSchema),
  adminCatalogController.updateProductStatus,
);

// Admin Categories
router.post(
  '/categories',
  authenticateMiddleware,
  authorize('categories.create'),
  validateRequest(createCategorySchema),
  categoryController.createCategory,
);

router.patch(
  '/categories/:id',
  authenticateMiddleware,
  authorize('categories.update'),
  validateRequest(updateCategorySchema),
  categoryController.updateCategory,
);

router.delete(
  '/categories/:id',
  authenticateMiddleware,
  authorize('categories.delete'),
  categoryController.deleteCategory,
);

// Admin Brands
router.post(
  '/brands',
  authenticateMiddleware,
  authorize('brands.create'),
  validateRequest(createBrandSchema),
  brandController.createBrand,
);

router.patch(
  '/brands/:id',
  authenticateMiddleware,
  authorize('brands.update'),
  validateRequest(updateBrandSchema),
  brandController.updateBrand,
);

router.delete(
  '/brands/:id',
  authenticateMiddleware,
  authorize('brands.delete'),
  brandController.deleteBrand,
);

export const adminCatalogRouter = router;
