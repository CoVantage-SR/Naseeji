import { SlugUtil } from '../../src/shared/utils/slug.util.js';
import { updateSupplierProfileSchema } from '../../src/modules/supplier/application/dtos/supplier.dto.js';
import {
  createStoreSchema,
  updateStoreSchema,
} from '../../src/modules/supplier/application/dtos/store.dto.js';

describe('Phase 03 Unit Tests — Supplier Domain, Store Domain & Mass Assignment Protection', () => {
  describe('SlugUtil', () => {
    it('should generate clean URL slug from string', () => {
      const rawName = 'Alexandria Cotton & Spinning Mills Ltd!';
      const slug = SlugUtil.slugify(rawName);
      expect(slug).toBe('alexandria-cotton-spinning-mills-ltd');
    });

    it('should incrementally generate unique slug when collision exists', async () => {
      const existingSlugs = new Set(['el-gharbeya-fabrics', 'el-gharbeya-fabrics-2']);

      const uniqueSlug = await SlugUtil.generateUniqueSlug('El-Gharbeya Fabrics', async (s) =>
        existingSlugs.has(s),
      );

      expect(uniqueSlug).toBe('el-gharbeya-fabrics-3');
    });
  });

  describe('Supplier Mass Assignment Protection (updateSupplierProfileSchema)', () => {
    it('should allow whitelisted supplier profile updates', () => {
      const validPayload = {
        companyName: 'Updated Nile Weaving',
        description: 'Quality Egyptian Textiles',
        businessType: 'manufacturer',
        city: 'Mahalla',
        website: 'https://nileweaving.com',
      };
      const result = updateSupplierProfileSchema.safeParse({ body: validPayload });
      expect(result.success).toBe(true);
    });

    it('should reject requests attempting to modify restricted security attributes', () => {
      const illegalPayload = {
        companyName: 'Attempted Tamper',
        verificationStatus: 'verified', // Forbidden attribute
      };
      const result = updateSupplierProfileSchema.safeParse({ body: illegalPayload });
      expect(result.success).toBe(false);
    });

    it('should reject attempts to mutate ratings or statistics', () => {
      const illegalPayload = {
        companyName: 'Rating Tamper',
        rating: 5.0, // Forbidden attribute
      };
      const result = updateSupplierProfileSchema.safeParse({ body: illegalPayload });
      expect(result.success).toBe(false);
    });
  });

  describe('Store DTO Validation', () => {
    it('should validate valid store creation payload', () => {
      const payload = {
        name: 'Alexandria Cotton Store',
        description: 'Official store for Alexandria Cotton Mills',
        isPublic: true,
      };
      const result = createStoreSchema.safeParse({ body: payload });
      expect(result.success).toBe(true);
    });

    it('should validate valid store update payload', () => {
      const payload = {
        name: 'New Store Name',
        description: 'Updated store description',
      };
      const result = updateStoreSchema.safeParse({ body: payload });
      expect(result.success).toBe(true);
    });
  });
});
