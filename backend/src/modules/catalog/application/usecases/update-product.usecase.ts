import crypto from 'crypto';
import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { UpdateProductDto } from '../dtos/product.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';
import { ForbiddenException } from '../../../../core/errors/forbidden.exception.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { IProductDocument } from '../../infrastructure/database/product.schema.js';

export class UpdateProductUseCase {
  constructor(
    private productRepo: ProductRepository,
    private supplierRepo: SupplierRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    productId: string,
    userId: string,
    userRole: string,
    dto: UpdateProductDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<IProductDocument> {
    const product = await this.productRepo.findById(productId);
    if (!product || product.status === 'archived') {
      throw new NotFoundException('Product not found');
    }

    const isAdmin = userRole === 'admin' || userRole === 'ADMIN';

    if (!isAdmin) {
      const supplier = await this.supplierRepo.findByUserId(userId);
      if (!supplier || product.supplierId !== supplier._id) {
        throw new ForbiddenException(
          'Access denied: You can only update products owned by your supplier account.',
        );
      }
    }

    const updates: Partial<IProductDocument> = {};

    if (dto.name && dto.name !== product.name) {
      updates.name = dto.name;
      updates.slug = await SlugUtil.generateUniqueSlug(dto.name, async (s) => {
        const existing = await this.productRepo.findBySlug(s);
        return Boolean(existing && existing._id !== productId);
      });
    }

    if (dto.sku && dto.sku !== product.sku) {
      const existingSku = await this.productRepo.findBySku(dto.sku);
      if (existingSku && existingSku._id !== productId) {
        throw new BusinessException(`Product SKU "${dto.sku}" already exists.`);
      }
      updates.sku = dto.sku;
    }

    if (dto.categoryId !== undefined) updates.categoryId = dto.categoryId;
    if (dto.subcategoryId !== undefined) updates.subcategoryId = dto.subcategoryId;
    if (dto.brandId !== undefined) updates.brandId = dto.brandId;
    if (dto.shortDescription !== undefined) updates.shortDescription = dto.shortDescription;
    if (dto.description !== undefined) updates.description = dto.description;
    if (dto.productType !== undefined) updates.productType = dto.productType;
    if (dto.price !== undefined) updates.price = dto.price;
    if (dto.compareAtPrice !== undefined) updates.compareAtPrice = dto.compareAtPrice;
    if (dto.currency !== undefined) updates.currency = dto.currency;
    if (dto.minimumOrderQuantity !== undefined)
      updates.minimumOrderQuantity = dto.minimumOrderQuantity;
    if (dto.stockQuantity !== undefined) updates.stockQuantity = dto.stockQuantity;
    if (dto.unit !== undefined) updates.unit = dto.unit;
    if (dto.leadTimeDays !== undefined) updates.leadTimeDays = dto.leadTimeDays;
    if (dto.visibility !== undefined) updates.visibility = dto.visibility;
    if (dto.isNegotiable !== undefined) updates.isNegotiable = dto.isNegotiable;
    if (dto.allowRFQ !== undefined) updates.allowRFQ = dto.allowRFQ;
    if (dto.originCountry !== undefined) updates.originCountry = dto.originCountry;
    if (dto.originCity !== undefined) updates.originCity = dto.originCity;
    if (dto.specifications !== undefined) updates.specifications = dto.specifications;
    if (dto.attributes !== undefined) updates.attributes = dto.attributes;
    if (dto.metaTitle !== undefined) updates.metaTitle = dto.metaTitle;
    if (dto.metaDescription !== undefined) updates.metaDescription = dto.metaDescription;
    if (dto.keywords !== undefined) updates.keywords = dto.keywords;

    // Supplier can transition to 'draft', 'pending_review', 'active', 'inactive', 'out_of_stock'
    if (dto.status !== undefined) {
      if (!isAdmin && dto.status === 'active' && product.status === 'draft') {
        // Supplier submitting product for review / activation
        updates.status = 'pending_review';
      } else {
        updates.status = dto.status;
      }
    }

    const updated = await this.productRepo.update(productId, updates);
    if (!updated) {
      throw new NotFoundException('Product not found for update');
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'PRODUCT_UPDATED',
      ipAddress,
      userAgent,
      metadata: { productId: updated._id, updates },
    });

    return updated;
  }
}
