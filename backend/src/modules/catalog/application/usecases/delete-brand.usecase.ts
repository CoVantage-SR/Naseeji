import crypto from 'crypto';
import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

export class DeleteBrandUseCase {
  constructor(
    private brandRepo: BrandRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    brandId: string,
    userId: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<boolean> {
    const brand = await this.brandRepo.findById(brandId);
    if (!brand || brand.status === 'archived') {
      throw new NotFoundException('Brand not found');
    }

    const success = await this.brandRepo.delete(brandId);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'BRAND_DELETED',
      ipAddress,
      userAgent,
      metadata: { brandId, name: brand.name },
    });

    return success;
  }
}
