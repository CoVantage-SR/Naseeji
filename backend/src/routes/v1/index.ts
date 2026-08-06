import { Router } from 'express';
import { healthRouter } from './health.router.js';
import { versionRouter } from './version.router.js';
import { enterpriseAuthRouter } from '../../modules/auth/presentation/routes/enterprise-auth.routes.js';

const router = Router();

router.use('/', healthRouter);
router.use('/', versionRouter);
router.use('/auth', enterpriseAuthRouter);

export const v1Router = router;
