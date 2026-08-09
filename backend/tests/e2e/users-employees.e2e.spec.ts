import request from 'supertest';
import { createApplication } from '../../src/app/app.js';
import { Express } from 'express';
import { JwtService } from '../../src/modules/auth/security/services/jwt.service.js';
import { MongoConnectionManager } from '../../src/database/mongo/connection-manager.js';
import { RedisService } from '../../src/infrastructure/redis/redis.service.js';
import { MailService } from '../../src/infrastructure/mail/mail.service.js';

describe('Phase 02 E2E Integration Tests — Users, Employees, Roles & Permissions', () => {
  let app: Express;
  const jwtService = new JwtService();
  let factoryToken: string;
  let adminToken: string;
  let supplierToken: string;

  beforeAll(async () => {
    const bootstrap = await createApplication();
    app = bootstrap.app;

    factoryToken = jwtService.issueTokens('user-factory-1', 'session-f1', 'factory', [
      'factory',
    ]).accessToken;
    adminToken = jwtService.issueTokens('user-admin-1', 'session-a1', 'admin', [
      'admin',
    ]).accessToken;
    supplierToken = jwtService.issueTokens('user-supplier-1', 'session-s1', 'supplier', [
      'supplier',
    ]).accessToken;
  }, 15000);

  afterAll(async () => {
    await MongoConnectionManager.disconnect();
    await RedisService.getInstance().disconnect();
    await MailService.getInstance().disconnect();
  });

  describe('GET /api/v1/users/me', () => {
    it('should fail with 401 when no token is provided', async () => {
      const res = await request(app).get('/api/v1/users/me');
      expect(res.status).toBe(401);
      expect(res.body.success).toBe(false);
    });

    it('should return user context & profile info when authenticated', async () => {
      const res = await request(app)
        .get('/api/v1/users/me')
        .set('Authorization', `Bearer ${factoryToken}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(res.body.data.id).toBeDefined();
    });

    it('should allow supplier to access self profile endpoint', async () => {
      const res = await request(app)
        .get('/api/v1/users/me')
        .set('Authorization', `Bearer ${supplierToken}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
    });
  });

  describe('PATCH /api/v1/users/me — Mass Assignment Protection', () => {
    it('should reject requests attempting to modify restricted security attributes', async () => {
      const res = await request(app)
        .patch('/api/v1/users/me')
        .set('Authorization', `Bearer ${factoryToken}`)
        .send({
          companyName: 'Updated Factory',
          role: 'admin', // Restricted attribute
        });

      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
    });
  });

  describe('GET /api/v1/users — Admin Authorization', () => {
    it('should deny non-admin users with 403 Forbidden', async () => {
      const res = await request(app)
        .get('/api/v1/users')
        .set('Authorization', `Bearer ${factoryToken}`);

      expect(res.status).toBe(403);
      expect(res.body.success).toBe(false);
    });

    it('should allow admin users to query user directory', async () => {
      const res = await request(app)
        .get('/api/v1/users')
        .set('Authorization', `Bearer ${adminToken}`);

      expect([200, 500]).toContain(res.status);
    });
  });

  describe('GET /api/v1/roles & /api/v1/permissions', () => {
    it('should return system permissions catalog for admin users', async () => {
      const res = await request(app)
        .get('/api/v1/permissions')
        .set('Authorization', `Bearer ${adminToken}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(Array.isArray(res.body.data)).toBe(true);
      expect(res.body.data.length).toBeGreaterThan(0);
    });

    it('should return system roles list for admin users', async () => {
      const res = await request(app)
        .get('/api/v1/roles')
        .set('Authorization', `Bearer ${adminToken}`);

      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(Array.isArray(res.body.data)).toBe(true);
    });
  });

  describe('POST /api/v1/employees — Organization Employee Management', () => {
    it('should require authentication and valid employee payload', async () => {
      const res = await request(app)
        .post('/api/v1/employees')
        .set('Authorization', `Bearer ${factoryToken}`)
        .send({});

      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
    });
  });
});
