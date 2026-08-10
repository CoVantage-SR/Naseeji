import {
  ProductRepository,
  ProductMarketplaceFilter,
} from '../../infrastructure/repositories/product.repository.js';
import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';

export class ListMarketplaceProductsUseCase {
  constructor(
    private productRepo: ProductRepository,
    private mediaRepo: ProductMediaRepository,
    private supplierRepo: SupplierRepository,
  ) {}

  public async execute(
    filters: ProductMarketplaceFilter = {},
    page = 1,
    limit = 20,
    sort = 'newest',
  ): Promise<{ items: any[]; total: number; page: number; totalPages: number }> {
    const { items, total } = await this.productRepo.listMarketplace(filters, page, limit, sort);

    const enrichedItems = await Promise.all(
      items.map(async (product) => {
        const [media, supplier] = await Promise.all([
          this.mediaRepo.findByProductId(product._id),
          this.supplierRepo.findById(product.supplierId),
        ]);

        const primaryMedia = media.find((m) => m.isPrimary) || media[0] || null;

        return {
          id: product._id,
          name: product.name,
          slug: product.slug,
          sku: product.sku,
          shortDescription: product.shortDescription,
          productType: product.productType,
          price: product.price,
          compareAtPrice: product.compareAtPrice,
          currency: product.currency,
          minimumOrderQuantity: product.minimumOrderQuantity,
          stockQuantity: product.stockQuantity,
          unit: product.unit,
          rating: product.rating,
          ratingCount: product.ratingCount,
          isFeatured: product.isFeatured,
          isNegotiable: product.isNegotiable,
          allowRFQ: product.allowRFQ,
          originCountry: product.originCountry,
          originCity: product.originCity,
          status: product.status,
          primaryImage: primaryMedia ? primaryMedia.url : null,
          supplier: supplier
            ? {
                id: supplier._id,
                companyName: supplier.companyName,
                isVerified: supplier.isVerified,
                rating: supplier.rating,
              }
            : null,
          createdAt: product.createdAt,
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
