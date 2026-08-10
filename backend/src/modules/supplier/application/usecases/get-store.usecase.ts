import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { StoreRepository } from '../../infrastructure/repositories/store.repository.js';
import { PublicStoreDto } from '../dtos/store.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { IStoreDocument } from '../../infrastructure/database/store.schema.js';

export class GetStoreUseCase {
  constructor(
    private supplierRepo: SupplierRepository,
    private storeRepo: StoreRepository,
  ) {}

  public async getSelfStore(userId: string): Promise<PublicStoreDto> {
    const supplier = await this.supplierRepo.findByUserId(userId);
    if (!supplier) {
      throw new NotFoundException('Supplier profile not found');
    }

    const store = await this.storeRepo.findBySupplierId(supplier._id);
    if (!store) {
      throw new NotFoundException('Store not found for this supplier');
    }

    return this.mapToDto(store, supplier);
  }

  public async getPublicStoreBySlug(slug: string): Promise<PublicStoreDto> {
    const store = await this.storeRepo.findBySlug(slug);
    if (!store || store.status !== 'active' || !store.isPublic) {
      throw new NotFoundException('Public store not found');
    }

    const supplier = await this.supplierRepo.findById(store.supplierId);
    if (!supplier || !supplier.isActive) {
      throw new NotFoundException('Store supplier is unavailable');
    }

    return this.mapToDto(store, supplier);
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
