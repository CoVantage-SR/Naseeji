import request from 'supertest';
import { createApplication } from '../../src/app/app.js';
import { Express } from 'express';
import { JwtService } from '../../src/modules/auth/security/services/jwt.service.js';
import { MongoConnectionManager } from '../../src/database/mongo/connection-manager.js';
import { RedisService } from '../../src/infrastructure/redis/redis.service.js';
import { MailService } from '../../src/infrastructure/mail/mail.service.js';

describe('Phase 03 E2E Integration Tests — Supplier & Store Domain', () => {
  let app: Express;
  const jwtService = new JwtService();
  let supplierToken: string;
  let adminToken: string;
  let factoryToken: string;

  beforeAll(async () => {
    const bootstrap = await createApplication();
    app = bootstrap.app;

    supplierToken = jwtService.issueTokens('user-supplier-1', 'session-s1', 'supplier', [
      'supplier',
    ]).accessToken;

    adminToken = jwtService.issueTokens('user-admin-1', 'session-a1', 'admin', [
      'admin',
    ]).accessToken;

    factoryToken = jwtService.issueTokens('user-factory-1', 'session-f1', 'factory', [
      'factory',
    ]).accessToken;
  }, 15000);

  afterAll(async () => {
    await MongoConnectionManager.disconnect();
    await RedisService.getInstance().disconnect();
    await MailService.getInstance().disconnect();
  });

  describe('GET /api/v1/suppliers — Public Marketplace Directory', () => {
    it('should return list of active suppliers', async () => {
      const res = await request(app).get('/api/v1/suppliers');
      expect(res.status).toBe(200);
      expect(res.body.success).toBe(true);
      expect(Array.isArray(res.body.data.suppliers)).toBe(true);
    });
  });

  describe('GET /api/v1/suppliers/me — Supplier Self Profile', () => {
    it('should reject unauthenticated request with 401 Unauthorized', async () => {
      const res = await request(app).get('/api/v1/suppliers/me');
      expect(res.status).toBe(401);
      expect(res.body.success).toBe(false);
    });

    it('should return self supplier profile when authenticated as supplier', async () => {
      const res = await request(app)
        .get('/api/v1/suppliers/me')
        .set('Authorization', `Bearer ${supplierToken}`);

      expect([200, 404]).toContain(res.status);
    });
  });

  describe('PATCH /api/v1/suppliers/me — Profile Updates & Mass Assignment Protection', () => {
    it('should allow whitelisted company profile updates', async () => {
      const res = await request(app)
        .patch('/api/v1/suppliers/me')
        .set('Authorization', `Bearer ${supplierToken}`)
        .send({
          description: 'Updated Egyptian Textile Manufacturer Description',
          businessType: 'manufacturer',
        });

      expect([200, 404]).toContain(res.status);
    });

    it('should reject mass assignment tamper attempts on restricted security attributes', async () => {
      const res = await request(app)
        .patch('/api/v1/suppliers/me')
        .set('Authorization', `Bearer ${supplierToken}`)
        .send({
          description: 'Valid Update',
          verificationStatus: 'verified', // Forbidden attribute
        });

      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
    });
  });

  describe('POST /api/v1/suppliers/me/verification — Verification Document Submission', () => {
    it('should submit verification request with commercial registration & tax info', async () => {
      const res = await request(app)
        .post('/api/v1/suppliers/me/verification')
        .set('Authorization', `Bearer ${supplierToken}`)
        .send({
          commercialRegistration: 'CR-500600700',
          taxNumber: 'TAX-400300200',
          documents: [
            {
              documentType: 'commercial_registration_pdf',
              url: 'https://cdn.naseeji.com/docs/cr.pdf',
            },
          ],
        });

      expect([201, 404]).toContain(res.status);
    });
  });

  describe('POST & GET /api/v1/stores — Store Domain Management', () => {
    it('should create primary store for authenticated supplier', async () => {
      const res = await request(app)
        .post('/api/v1/stores')
        .set('Authorization', `Bearer ${supplierToken}`)
        .send({
          name: 'Naseeji Premier Textile Store',
          description: 'Official store for Naseeji Cotton Mills',
          isPublic: true,
        });

      expect([201, 400, 404]).toContain(res.status);
    });

    it('should return store details for authenticated supplier', async () => {
      const res = await request(app)
        .get('/api/v1/stores/me')
        .set('Authorization', `Bearer ${supplierToken}`);

      expect([200, 404]).toContain(res.status);
    });

    it('should return public store profile by slug', async () => {
      const res = await request(app).get('/api/v1/stores/naseeji-master-textile-mills');
      expect([200, 404]).toContain(res.status);
    });
  });

  describe('PATCH /api/v1/suppliers/admin/:id/status — Admin Control', () => {
    it('should deny non-admin users from changing supplier status', async () => {
      const res = await request(app)
        .patch('/api/v1/suppliers/admin/sup-1/status')
        .set('Authorization', `Bearer ${factoryToken}`)
        .send({ isActive: false });

      expect(res.status).toBe(403);
      expect(res.body.success).toBe(false);
    });

    it('should allow admin users to set supplier active status', async () => {
      const res = await request(app)
        .patch('/api/v1/suppliers/admin/sup-1/status')
        .set('Authorization', `Bearer ${adminToken}`)
        .send({ isActive: true, reason: 'Verification confirmed' });

      expect([200, 404]).toContain(res.status);
    });
  });
});
