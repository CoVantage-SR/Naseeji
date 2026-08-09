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

const router = Router();

router.use('/', healthRouter);
router.use('/', versionRouter);
router.use('/auth', enterpriseAuthRouter);
router.use('/users', userRouter);
router.use('/employees', employeeRouter);
router.use('/roles', roleApiRouter);
router.use('/permissions', permissionApiRouter);

export const v1Router = router;
