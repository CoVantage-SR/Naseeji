import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { ReorderProductMediaDto } from '../dtos/product-media.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { ForbiddenException } from '../../../../core/errors/forbidden.exception.js';

export class ReorderProductMediaUseCase {
  constructor(
    private mediaRepo: ProductMediaRepository,
    private productRepo: ProductRepository,
    private supplierRepo: SupplierRepository,
  ) {}

  public async execute(
    userId: string,
    userRole: string,
    dto: ReorderProductMediaDto,
  ): Promise<boolean> {
    const product = await this.productRepo.findById(dto.productId);
    if (!product || product.status === 'archived') {
      throw new NotFoundException('Product not found');
    }

    const isAdmin = userRole === 'admin' || userRole === 'ADMIN';

    if (!isAdmin) {
      const supplier = await this.supplierRepo.findByUserId(userId);
      if (!supplier || product.supplierId !== supplier._id) {
        throw new ForbiddenException(
          'Access denied: You can only reorder media for your own products.',
        );
      }
    }

    await this.mediaRepo.updateSortOrder(dto.items);
    return true;
  }
}
