import crypto from 'crypto';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { StoreRepository } from '../../infrastructure/repositories/store.repository.js';
import { UpdateStoreDto, PublicStoreDto } from '../dtos/store.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { IStoreDocument } from '../../infrastructure/database/store.schema.js';

export class UpdateStoreUseCase {
  constructor(
    private supplierRepo: SupplierRepository,
    private storeRepo: StoreRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    userId: string,
    dto: UpdateStoreDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<PublicStoreDto> {
    const supplier = await this.supplierRepo.findByUserId(userId);
    if (!supplier) {
      throw new NotFoundException('Supplier profile not found');
    }

    const store = await this.storeRepo.findBySupplierId(supplier._id);
    if (!store) {
      throw new NotFoundException('Store profile not found');
    }

    const updates: Record<string, unknown> = { ...dto };

    if (dto.name && dto.name !== store.name) {
      updates.slug = await SlugUtil.generateUniqueSlug(dto.name, async (s) => {
        const found = await this.storeRepo.findBySlug(s);
        return Boolean(found && found._id !== store._id);
      });
    }

    const updatedStore = await this.storeRepo.updateBySupplierId(supplier._id, updates);
    if (!updatedStore) {
      throw new NotFoundException('Failed to update store');
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'STORE_UPDATED',
      ipAddress,
      userAgent,
      metadata: { storeId: store._id, updatedFields: Object.keys(dto) },
    });

    return this.mapToDto(updatedStore, supplier);
  }

  private mapToDto(
    store: IStoreDocument,
    supplier?: {
      companyName: string;
      supplierCategory: string;
      isVerified: boolean;
      rating: number;
      ratingCount: number;
    },
  ): PublicStoreDto {
    return {
      id: store._id,
      supplierId: store.supplierId,
      name: store.name,
      slug: store.slug,
      description: store.description,
      logo: store.logo,
      coverImage: store.coverImage,
      status: store.status,
      isPublic: store.isPublic,
      supplier: supplier
        ? {
            companyName: supplier.companyName,
            supplierCategory: supplier.supplierCategory,
            isVerified: supplier.isVerified || false,
            rating: supplier.rating || 0,
            ratingCount: supplier.ratingCount || 0,
          }
        : undefined,
      createdAt: store.createdAt ? store.createdAt.toISOString() : undefined,
      updatedAt: store.updatedAt ? store.updatedAt.toISOString() : undefined,
    };
  }
}
