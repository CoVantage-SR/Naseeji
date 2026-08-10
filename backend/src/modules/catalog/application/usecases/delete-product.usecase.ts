import crypto from 'crypto';
import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { ForbiddenException } from '../../../../core/errors/forbidden.exception.js';

export class DeleteProductUseCase {
  constructor(
    private productRepo: ProductRepository,
    private categoryRepo: CategoryRepository,
    private supplierRepo: SupplierRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    productId: string,
    userId: string,
    userRole: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<boolean> {
    const product = await this.productRepo.findById(productId);
    if (!product || product.status === 'archived') {
      throw new NotFoundException('Product not found');
    }

    const isAdmin = userRole === 'admin' || userRole === 'ADMIN';

    if (!isAdmin) {
      const supplier = await this.supplierRepo.findByUserId(userId);
      if (!supplier || product.supplierId !== supplier._id) {
        throw new ForbiddenException(
          'Access denied: You can only archive products owned by your supplier account.',
        );
      }
    }

    const success = await this.productRepo.delete(productId);

    if (success) {
      await this.categoryRepo.incrementProductCount(product.categoryId, -1);

      await this.securityLogRepo.logAction({
        _id: crypto.randomUUID(),
        userId,
        action: 'PRODUCT_ARCHIVED',
        ipAddress,
        userAgent,
        metadata: { productId, name: product.name, sku: product.sku },
      });
    }

    return success;
  }
}
