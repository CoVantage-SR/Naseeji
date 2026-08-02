import { Router } from 'express';
import { healthRouter } from './health.router.js';
import { versionRouter } from './version.router.js';
import { authRouter } from '../../modules/auth/presentation/routes/auth.router.js';
import { adminAuthRouter } from '../../modules/auth/presentation/routes/admin-auth.router.js';

const router = Router();

router.use('/', healthRouter);
router.use('/', versionRouter);
router.use('/auth', authRouter);
router.use('/admin/auth', adminAuthRouter);

export const v1Router = router;
