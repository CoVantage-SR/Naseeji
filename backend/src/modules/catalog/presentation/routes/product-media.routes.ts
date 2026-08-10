import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { authorize } from '@middleware/authorize.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import {
  addProductMediaSchema,
  reorderProductMediaSchema,
} from '../../application/dtos/product-media.dto.js';

import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';

import { AddProductMediaUseCase } from '../../application/usecases/add-product-media.usecase.js';
import { DeleteProductMediaUseCase } from '../../application/usecases/delete-product-media.usecase.js';
import { ReorderProductMediaUseCase } from '../../application/usecases/reorder-product-media.usecase.js';

import { ProductMediaController } from '../controllers/product-media.controller.js';

const mediaRepo = new ProductMediaRepository();
const productRepo = new ProductRepository();
const supplierRepo = new SupplierRepository();
const securityLogRepo = new SecurityLogRepository();

const addMediaUseCase = new AddProductMediaUseCase(
  mediaRepo,
  productRepo,
  supplierRepo,
  securityLogRepo,
);

const deleteMediaUseCase = new DeleteProductMediaUseCase(
  mediaRepo,
  productRepo,
  supplierRepo,
  securityLogRepo,
);

const reorderMediaUseCase = new ReorderProductMediaUseCase(
  mediaRepo,
  productRepo,
  supplierRepo,
);

const mediaController = new ProductMediaController(
  addMediaUseCase,
  deleteMediaUseCase,
  reorderMediaUseCase,
);

const router = Router();

router.post(
  '/',
  authenticateMiddleware,
  authorize('product_media.create'),
  validateRequest(addProductMediaSchema),
  mediaController.addMedia,
);

router.post(
  '/reorder',
  authenticateMiddleware,
  authorize('product_media.create'),
  validateRequest(reorderProductMediaSchema),
  mediaController.reorderMedia,
);

router.delete(
  '/:id',
  authenticateMiddleware,
  authorize('product_media.delete'),
  mediaController.deleteMedia,
);

export const productMediaRouter = router;
