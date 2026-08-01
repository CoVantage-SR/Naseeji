import { Router, Request, Response } from 'express';

const router = Router();

router.get('/version', (_req: Request, res: Response) => {
  const versionData = {
    name: 'NASEEJI Enterprise Backend API',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development',
    apiVersion: 'v1',
  };

  res.success(versionData, 'System Version Information', 200);
});

export const versionRouter = router;
