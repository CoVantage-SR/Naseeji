import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { authorize } from '@middleware/authorize.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import {
  createProductSchema,
  updateProductSchema,
} from '../../application/dtos/product.dto.js';

import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { StoreRepository } from '../../../supplier/infrastructure/repositories/store.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';

import { CreateProductUseCase } from '../../application/usecases/create-product.usecase.js';
import { UpdateProductUseCase } from '../../application/usecases/update-product.usecase.js';
import { DeleteProductUseCase } from '../../application/usecases/delete-product.usecase.js';
import { GetProductUseCase } from '../../application/usecases/get-product.usecase.js';
import { ListMarketplaceProductsUseCase } from '../../application/usecases/list-marketplace-products.usecase.js';
import { ListSupplierProductsUseCase } from '../../application/usecases/list-supplier-products.usecase.js';

import { ProductController } from '../controllers/product.controller.js';

const productRepo = new ProductRepository();
const categoryRepo = new CategoryRepository();
const brandRepo = new BrandRepository();
const mediaRepo = new ProductMediaRepository();
const supplierRepo = new SupplierRepository();
const storeRepo = new StoreRepository();
const securityLogRepo = new SecurityLogRepository();

const createProductUseCase = new CreateProductUseCase(
  productRepo,
  categoryRepo,
  brandRepo,
  supplierRepo,
  storeRepo,
  securityLogRepo,
);

const updateProductUseCase = new UpdateProductUseCase(
  productRepo,
  supplierRepo,
  securityLogRepo,
);

const deleteProductUseCase = new DeleteProductUseCase(
  productRepo,
  categoryRepo,
  supplierRepo,
  securityLogRepo,
);

const getProductUseCase = new GetProductUseCase(
  productRepo,
  categoryRepo,
  brandRepo,
  mediaRepo,
  supplierRepo,
  storeRepo,
);

const listMarketplaceProductsUseCase = new ListMarketplaceProductsUseCase(
  productRepo,
  mediaRepo,
  supplierRepo,
);

const listSupplierProductsUseCase = new ListSupplierProductsUseCase(
  productRepo,
  supplierRepo,
  mediaRepo,
);

export const productController = new ProductController(
  createProductUseCase,
  updateProductUseCase,
  deleteProductUseCase,
  getProductUseCase,
  listMarketplaceProductsUseCase,
  listSupplierProductsUseCase,
);

const router = Router();

// Public Marketplace product listing & details
router.get('/slug/:slug', productController.getProductBySlug);
router.get('/:id', productController.getProductById);
router.get('/', productController.listMarketplaceProducts);

// Supplier product management
router.post(
  '/',
  authenticateMiddleware,
  authorize('products.create'),
  validateRequest(createProductSchema),
  productController.createProduct,
);

router.patch(
  '/:id',
  authenticateMiddleware,
  authorize('products.update'),
  validateRequest(updateProductSchema),
  productController.updateProduct,
);

router.delete(
  '/:id',
  authenticateMiddleware,
  authorize('products.delete'),
  productController.deleteProduct,
);

export const productRouter = router;
