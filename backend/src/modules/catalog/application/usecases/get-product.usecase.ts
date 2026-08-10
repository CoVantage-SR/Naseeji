import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { StoreRepository } from '../../../supplier/infrastructure/repositories/store.repository.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

export class GetProductUseCase {
  constructor(
    private productRepo: ProductRepository,
    private categoryRepo: CategoryRepository,
    private brandRepo: BrandRepository,
    private mediaRepo: ProductMediaRepository,
    private supplierRepo: SupplierRepository,
    private storeRepo: StoreRepository,
  ) {}

  public async getById(id: string, isPublic = true): Promise<any> {
    const product = await this.productRepo.findById(id);
    if (!product || product.status === 'archived') {
      throw new NotFoundException('Product not found');
    }

    if (isPublic && (product.status !== 'active' || product.visibility !== 'public')) {
      throw new NotFoundException('Product not found or not available in marketplace');
    }

    if (isPublic) {
      await this.productRepo.incrementViewCount(id);
    }

    return this.enrichProduct(product);
  }

  public async getBySlug(slug: string): Promise<any> {
    const product = await this.productRepo.findBySlug(slug);
    if (!product || product.status === 'archived' || product.status !== 'active') {
      throw new NotFoundException('Product not found');
    }

    await this.productRepo.incrementViewCount(product._id);
    return this.enrichProduct(product);
  }

  private async enrichProduct(product: any): Promise<any> {
    const [supplier, store, category, brand, media] = await Promise.all([
      this.supplierRepo.findById(product.supplierId),
      this.storeRepo.findById(product.storeId),
      this.categoryRepo.findById(product.categoryId),
      product.brandId ? this.brandRepo.findById(product.brandId) : Promise.resolve(null),
      this.mediaRepo.findByProductId(product._id),
    ]);

    return {
      ...product,
      supplier: supplier
        ? {
            id: supplier._id,
            companyName: supplier.companyName,
            slug: supplier.slug,
            isVerified: supplier.isVerified,
            verificationLevel: supplier.verificationLevel,
            rating: supplier.rating,
            ratingCount: supplier.ratingCount,
            governorate: supplier.governorate,
            city: supplier.city,
            country: supplier.country,
          }
        : null,
      store: store
        ? {
            id: store._id,
            name: store.name,
            slug: store.slug,
            logo: store.logo,
          }
        : null,
      category: category
        ? {
            id: category._id,
            name: category.name,
            slug: category.slug,
          }
        : null,
      brand: brand
        ? {
            id: brand._id,
            name: brand.name,
            slug: brand.slug,
            logo: brand.logo,
          }
        : null,
      media,
    };
  }
}
