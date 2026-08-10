import { Router } from 'express';
import { healthRouter } from './health.router.js';
import { versionRouter } from './version.router.js';
import { enterpriseAuthRouter } from '../../modules/auth/presentation/routes/enterprise-auth.routes.js';
import { userRouter } from '../../modules/users/presentation/routes/user.routes.js';
import { employeeRouter } from '../../modules/employees/presentation/routes/employee.routes.js';
import {
  roleApiRouter,
  permissionApiRouter,
} from '../../modules/auth/authorization/presentation/routes/role-permission.routes.js';
import { supplierRouter } from '../../modules/supplier/presentation/routes/supplier.routes.js';
import { storeRouter } from '../../modules/supplier/presentation/routes/store.routes.js';
import { categoryRouter } from '../../modules/catalog/presentation/routes/category.routes.js';
import { brandRouter } from '../../modules/catalog/presentation/routes/brand.routes.js';
import { productRouter } from '../../modules/catalog/presentation/routes/product.routes.js';
import { productMediaRouter } from '../../modules/catalog/presentation/routes/product-media.routes.js';
import { adminCatalogRouter } from '../../modules/catalog/presentation/routes/admin-catalog.routes.js';

const router = Router();

router.use('/', healthRouter);
router.use('/', versionRouter);
router.use('/auth', enterpriseAuthRouter);
router.use('/users', userRouter);
router.use('/employees', employeeRouter);
router.use('/roles', roleApiRouter);
router.use('/permissions', permissionApiRouter);
router.use('/suppliers', supplierRouter);
router.use('/stores', storeRouter);
router.use('/categories', categoryRouter);
router.use('/brands', brandRouter);
router.use('/products', productRouter);
router.use('/product-media', productMediaRouter);
router.use('/admin', adminCatalogRouter);

export const v1Router = router;
