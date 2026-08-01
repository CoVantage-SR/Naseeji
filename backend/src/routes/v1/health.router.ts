import { Router, Request, Response } from 'express';
import { MongoHealthChecker } from '../../database/mongo/health-checker.js';

const router = Router();

router.get('/health', async (_req: Request, res: Response) => {
  const mongoHealth = await MongoHealthChecker.check();
  const memoryUsage = process.memoryUsage();

  const healthData = {
    status: mongoHealth.status === 'up' ? 'UP' : 'DEGRADED',
    timestamp: new Date().toISOString(),
    uptimeSeconds: Math.floor(process.uptime()),
    database: mongoHealth,
    memory: {
      rssMB: Math.round(memoryUsage.rss / 1024 / 1024),
      heapTotalMB: Math.round(memoryUsage.heapTotal / 1024 / 1024),
      heapUsedMB: Math.round(memoryUsage.heapUsed / 1024 / 1024),
    },
  };

  const statusCode = mongoHealth.status === 'up' ? 200 : 503;
  res.success(healthData, 'System Health Status', statusCode);
});

export const healthRouter = router;
