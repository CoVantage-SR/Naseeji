import { Router } from 'express';
import { healthRouter } from './health.router.js';
import { versionRouter } from './version.router.js';

const router = Router();

router.use('/', healthRouter);
router.use('/', versionRouter);

export const v1Router = router;
