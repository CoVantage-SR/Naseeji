import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

export class ListSupplierProductsUseCase {
  constructor(
    private productRepo: ProductRepository,
    private supplierRepo: SupplierRepository,
    private mediaRepo: ProductMediaRepository,
  ) {}

  public async execute(
    userId: string,
    filters: { status?: string; search?: string } = {},
    page = 1,
    limit = 20,
  ): Promise<{ items: any[]; total: number; page: number; totalPages: number }> {
    const supplier = await this.supplierRepo.findByUserId(userId);
    if (!supplier) {
      throw new NotFoundException('Supplier profile not found');
    }

    const { items, total } = await this.productRepo.listBySupplier(
      supplier._id,
      filters,
      page,
      limit,
    );

    const enrichedItems = await Promise.all(
      items.map(async (product) => {
        const media = await this.mediaRepo.findByProductId(product._id);
        const primaryMedia = media.find((m) => m.isPrimary) || media[0] || null;

        return {
          ...product,
          id: product._id,
          primaryImage: primaryMedia ? primaryMedia.url : null,
          mediaCount: media.length,
        };
      }),
    );

    return {
      items: enrichedItems,
      total,
      page,
      totalPages: Math.ceil(total / limit) || 1,
    };
  }
}
