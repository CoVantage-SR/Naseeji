import crypto from 'crypto';
import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { ProductStatus } from '../../domain/catalog.types.js';
import { IProductDocument } from '../../infrastructure/database/product.schema.js';

export class AdminProductManagementUseCase {
  constructor(
    private productRepo: ProductRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async listProducts(
    filters: Record<string, any> = {},
    page = 1,
    limit = 20,
  ): Promise<{ items: IProductDocument[]; total: number; page: number; totalPages: number }> {
    const { items, total } = await this.productRepo.listAdmin(filters, page, limit);
    return {
      items,
      total,
      page,
      totalPages: Math.ceil(total / limit) || 1,
    };
  }

  public async updateProductStatus(
    productId: string,
    userId: string,
    status: ProductStatus,
    notes: string | undefined,
    ipAddress: string,
    userAgent: string,
  ): Promise<IProductDocument> {
    const product = await this.productRepo.findById(productId);
    if (!product) {
      throw new NotFoundException('Product not found');
    }

    const updates: Partial<IProductDocument> = { status };
    if (status === 'active' && !product.publishedAt) {
      updates.publishedAt = new Date();
    }

    const updated = await this.productRepo.update(productId, updates);
    if (!updated) {
      throw new NotFoundException('Product not found for status update');
    }

    let action = 'PRODUCT_STATUS_UPDATED';
    if (status === 'active') action = 'PRODUCT_APPROVED';
    else if (status === 'rejected') action = 'PRODUCT_REJECTED';
    else if (status === 'archived') action = 'PRODUCT_ARCHIVED';

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action,
      ipAddress,
      userAgent,
      metadata: { productId: updated._id, status, notes, sku: updated.sku },
    });

    return updated;
  }
}
