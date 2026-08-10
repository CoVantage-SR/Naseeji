import crypto from 'crypto';
import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { CreateBrandDto } from '../dtos/brand.dto.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { IBrandDocument } from '../../infrastructure/database/brand.schema.js';

export class CreateBrandUseCase {
  constructor(
    private brandRepo: BrandRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    userId: string,
    dto: CreateBrandDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<IBrandDocument> {
    const slug = await SlugUtil.generateUniqueSlug(dto.name, async (s) => {
      const existing = await this.brandRepo.findBySlug(s);
      return Boolean(existing);
    });

    const brand = await this.brandRepo.create({
      _id: crypto.randomUUID(),
      name: dto.name,
      slug,
      description: dto.description,
      logo: dto.logo,
      status: dto.status || 'active',
    });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'BRAND_CREATED',
      ipAddress,
      userAgent,
      metadata: { brandId: brand._id, name: brand.name, slug: brand.slug },
    });

    return brand;
  }
}
