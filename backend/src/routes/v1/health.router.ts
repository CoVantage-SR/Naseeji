import { Router, Request, Response } from 'express';
import { MongoHealthChecker } from '../../database/mongo/health-checker.js';
import { RedisService } from '../../infrastructure/redis/redis.service.js';
import { MinioService } from '../../infrastructure/storage/minio.service.js';
import { MailService } from '../../infrastructure/mail/mail.service.js';

const router = Router();

// Full Health Telemetry Report
router.get('/health', async (_req: Request, res: Response) => {
  const mongoHealth = await MongoHealthChecker.check();
  const redisHealth = await RedisService.getInstance().checkHealth();
  const minioHealth = await MinioService.getInstance().checkHealth();
  const mailHealth = await MailService.getInstance().checkHealth();
  const memoryUsage = process.memoryUsage();

  const isHealthy =
    mongoHealth.status === 'up' &&
    redisHealth.status === 'UP' &&
    minioHealth.status === 'UP' &&
    mailHealth.status === 'UP';

  const healthData = {
    status: isHealthy ? 'UP' : 'DEGRADED',
    timestamp: new Date().toISOString(),
    uptimeSeconds: Math.floor(process.uptime()),
    services: {
      database: mongoHealth,
      redis: redisHealth,
      minio: minioHealth,
      mail: mailHealth,
    },
    memory: {
      rssMB: Math.round(memoryUsage.rss / 1024 / 1024),
      heapTotalMB: Math.round(memoryUsage.heapTotal / 1024 / 1024),
      heapUsedMB: Math.round(memoryUsage.heapUsed / 1024 / 1024),
    },
  };

  const statusCode = isHealthy ? 200 : 503;
  res.success(healthData, 'System Health Status', statusCode);
});

// Docker & Kubernetes Readiness Probe
router.get('/ready', async (_req: Request, res: Response) => {
  const mongoHealth = await MongoHealthChecker.check();
  const redisHealth = await RedisService.getInstance().checkHealth();
  const minioHealth = await MinioService.getInstance().checkHealth();
  const mailHealth = await MailService.getInstance().checkHealth();

  const isReady =
    mongoHealth.status === 'up' &&
    redisHealth.status === 'UP' &&
    minioHealth.status === 'UP' &&
    mailHealth.status === 'UP';

  if (isReady) {
    res.status(200).json({ status: 'READY', message: 'All dependency services operational' });
  } else {
    res.status(503).json({
      status: 'NOT_READY',
      services: {
        database: mongoHealth.status,
        redis: redisHealth.status,
        minio: minioHealth.status,
        mail: mailHealth.status,
      },
    });
  }
});

// Docker & Kubernetes Liveness Probe
router.get('/live', (_req: Request, res: Response) => {
  res.status(200).json({ status: 'ALIVE', timestamp: new Date().toISOString() });
});

export const healthRouter = router;
