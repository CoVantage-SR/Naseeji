import crypto from 'crypto';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { StoreRepository } from '../../infrastructure/repositories/store.repository.js';
import { CreateStoreDto, PublicStoreDto } from '../dtos/store.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { IStoreDocument } from '../../infrastructure/database/store.schema.js';

export class CreateStoreUseCase {
  constructor(
    private supplierRepo: SupplierRepository,
    private storeRepo: StoreRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    userId: string,
    dto: CreateStoreDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<PublicStoreDto> {
    const supplier = await this.supplierRepo.findByUserId(userId);
    if (!supplier) {
      throw new NotFoundException('Supplier profile not found');
    }

    if (!supplier.isActive) {
      throw new BusinessException(
        'Inactive or suspended suppliers cannot create marketplace stores.',
      );
    }

    const existingStore = await this.storeRepo.findBySupplierId(supplier._id);
    if (existingStore) {
      throw new BusinessException('Supplier already has a registered marketplace store.');
    }

    const slug = await SlugUtil.generateUniqueSlug(dto.name, async (s) => {
      const found = await this.storeRepo.findBySlug(s);
      return Boolean(found);
    });

    const storeDoc = await this.storeRepo.create({
      _id: crypto.randomUUID(),
      supplierId: supplier._id,
      name: dto.name,
      slug,
      description: dto.description,
      logo: dto.logo || supplier.logo,
      coverImage: dto.coverImage || supplier.coverImage,
      status: 'active',
      isPublic: dto.isPublic !== false,
    });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'STORE_CREATED',
      ipAddress,
      userAgent,
      metadata: { supplierId: supplier._id, storeId: storeDoc._id, slug: storeDoc.slug },
    });

    return this.mapToDto(storeDoc, supplier);
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
