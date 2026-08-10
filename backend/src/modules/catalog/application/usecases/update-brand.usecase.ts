import crypto from 'crypto';
import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { UpdateBrandDto } from '../dtos/brand.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { IBrandDocument } from '../../infrastructure/database/brand.schema.js';

export class UpdateBrandUseCase {
  constructor(
    private brandRepo: BrandRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    brandId: string,
    userId: string,
    dto: UpdateBrandDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<IBrandDocument> {
    const brand = await this.brandRepo.findById(brandId);
    if (!brand || brand.status === 'archived') {
      throw new NotFoundException('Brand not found');
    }

    const updates: Partial<IBrandDocument> = {};

    if (dto.name && dto.name !== brand.name) {
      updates.name = dto.name;
      updates.slug = await SlugUtil.generateUniqueSlug(dto.name, async (s) => {
        const existing = await this.brandRepo.findBySlug(s);
        return Boolean(existing && existing._id !== brandId);
      });
    }

    if (dto.description !== undefined) updates.description = dto.description;
    if (dto.logo !== undefined) updates.logo = dto.logo;
    if (dto.status !== undefined) updates.status = dto.status;

    const updated = await this.brandRepo.update(brandId, updates);
    if (!updated) {
      throw new NotFoundException('Brand not found for update');
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'BRAND_UPDATED',
      ipAddress,
      userAgent,
      metadata: { brandId: updated._id, updates },
    });

    return updated;
  }
}
