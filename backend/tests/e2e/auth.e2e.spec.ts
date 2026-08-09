import request from 'supertest';
import { createApplication } from '../../src/app/app.js';
import { Express } from 'express';
import { MongoConnectionManager } from '../../src/database/mongo/connection-manager.js';
import { RedisService } from '../../src/infrastructure/redis/redis.service.js';
import { MailService } from '../../src/infrastructure/mail/mail.service.js';

describe('Auth & Identity End-to-End API Test Suite', () => {
  let app: Express;

  beforeAll(async () => {
    const bootstrap = await createApplication();
    app = bootstrap.app;
  }, 10000);

  afterAll(async () => {
    await MongoConnectionManager.disconnect();
    await RedisService.getInstance().disconnect();
    await MailService.getInstance().disconnect();
  });

  describe('GET /api/v1/health', () => {
    it('should return system health status', async () => {
      const res = await request(app).get('/api/v1/health');
      expect([200, 503]).toContain(res.status);
      expect(res.body.data.status).toBeDefined();
    });
  });

  describe('GET /api/v1/version', () => {
    it('should return system version information', async () => {
      const res = await request(app).get('/api/v1/version');
      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data.version).toBe('1.0.0');
    });
  });

  describe('POST /api/v1/auth/register/factory - Input Validation', () => {
    it('should fail registration when required fields are missing', async () => {
      const res = await request(app).post('/api/v1/auth/register/factory').send({});
      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
    });
  });
});
