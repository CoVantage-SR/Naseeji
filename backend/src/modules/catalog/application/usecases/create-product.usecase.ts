import crypto from 'crypto';
import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { StoreRepository } from '../../../supplier/infrastructure/repositories/store.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { CreateProductDto } from '../dtos/product.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { IProductDocument } from '../../infrastructure/database/product.schema.js';

export class CreateProductUseCase {
  constructor(
    private productRepo: ProductRepository,
    private categoryRepo: CategoryRepository,
    private brandRepo: BrandRepository,
    private supplierRepo: SupplierRepository,
    private storeRepo: StoreRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    userId: string,
    dto: CreateProductDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<IProductDocument> {
    // 1. Verify supplier identity and active status
    const supplier = await this.supplierRepo.findByUserId(userId);
    if (!supplier || !supplier.isActive) {
      throw new BusinessException('Active supplier account required to create products.');
    }

    // 2. Verify store ownership and active status
    const store = await this.storeRepo.findBySupplierId(supplier._id);
    if (!store || store.status !== 'active') {
      throw new BusinessException('Active marketplace store required to create products.');
    }

    // 3. Verify category existence
    const category = await this.categoryRepo.findById(dto.categoryId);
    if (!category || category.status === 'archived') {
      throw new NotFoundException('Specified category not found');
    }

    // 4. Verify subcategory if provided
    if (dto.subcategoryId) {
      const subcat = await this.categoryRepo.findById(dto.subcategoryId);
      if (!subcat || subcat.status === 'archived') {
        throw new NotFoundException('Specified subcategory not found');
      }
    }

    // 5. Verify brand if provided
    if (dto.brandId) {
      const brand = await this.brandRepo.findById(dto.brandId);
      if (!brand || brand.status === 'archived') {
        throw new NotFoundException('Specified brand not found');
      }
    }

    // 6. Verify SKU uniqueness
    const existingSku = await this.productRepo.findBySku(dto.sku);
    if (existingSku) {
      throw new BusinessException(`Product SKU "${dto.sku}" already exists.`);
    }

    // 7. Generate unique slug
    const slug = await SlugUtil.generateUniqueSlug(dto.name, async (s) => {
      const existing = await this.productRepo.findBySlug(s);
      return Boolean(existing);
    });

    const productDoc = await this.productRepo.create({
      _id: crypto.randomUUID(),
      supplierId: supplier._id,
      storeId: store._id,
      categoryId: dto.categoryId,
      subcategoryId: dto.subcategoryId,
      brandId: dto.brandId,
      sku: dto.sku,
      name: dto.name,
      slug,
      shortDescription: dto.shortDescription,
      description: dto.description,

      productType: dto.productType || 'physical',
      price: dto.price,
      compareAtPrice: dto.compareAtPrice,
      currency: dto.currency || 'EGP',
      minimumOrderQuantity: dto.minimumOrderQuantity || 1,
      stockQuantity: dto.stockQuantity ?? 0,
      unit: dto.unit || 'piece',
      leadTimeDays: dto.leadTimeDays ?? 1,

      status: 'draft',
      visibility: dto.visibility || 'public',
      isFeatured: false,
      isNegotiable: dto.isNegotiable ?? true,
      allowRFQ: dto.allowRFQ ?? true,
      rating: 0,
      ratingCount: 0,
      totalOrders: 0,
      viewCount: 0,

      originCountry: dto.originCountry || supplier.country || 'Egypt',
      originCity: dto.originCity || supplier.city || supplier.governorate,
      specifications: dto.specifications || [],
      attributes: dto.attributes || {},

      metaTitle: dto.metaTitle,
      metaDescription: dto.metaDescription,
      keywords: dto.keywords || [],
    });

    await this.categoryRepo.incrementProductCount(dto.categoryId, 1);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'PRODUCT_CREATED',
      ipAddress,
      userAgent,
      metadata: {
        productId: productDoc._id,
        supplierId: supplier._id,
        storeId: store._id,
        sku: productDoc.sku,
        name: productDoc.name,
      },
    });

    return productDoc;
  }
}
