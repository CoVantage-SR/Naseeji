import crypto from 'crypto';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { UpdateSupplierProfileDto, PrivateSupplierDto } from '../dtos/supplier.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { GetSupplierProfileUseCase } from './get-supplier-profile.usecase.js';

export class UpdateSupplierProfileUseCase {
  constructor(
    private supplierRepo: SupplierRepository,
    private securityLogRepo: SecurityLogRepository,
    private getSupplierProfileUseCase: GetSupplierProfileUseCase,
  ) {}

  public async execute(
    userId: string,
    dto: UpdateSupplierProfileDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<PrivateSupplierDto> {
    const existing = await this.supplierRepo.findByUserId(userId);
    if (!existing) {
      throw new NotFoundException('Supplier profile not found');
    }

    const updates: Record<string, unknown> = { ...dto };

    // If companyName changes and no slug exists or user is updating name, recalculate unique slug
    if (dto.companyName && dto.companyName !== existing.companyName) {
      updates.slug = await SlugUtil.generateUniqueSlug(dto.companyName, async (slug) => {
        const found = await this.supplierRepo.findBySlug(slug);
        return Boolean(found && found._id !== existing._id);
      });
    }

    const updated = await this.supplierRepo.updateByUserId(userId, updates);
    if (!updated) {
      throw new NotFoundException('Failed to update supplier profile');
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'SUPPLIER_UPDATED',
      ipAddress,
      userAgent,
      metadata: { supplierId: existing._id, updatedFields: Object.keys(dto) },
    });

    return this.getSupplierProfileUseCase.getSelfProfile(userId);
  }
}
