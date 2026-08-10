import crypto from 'crypto';
import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { ForbiddenException } from '../../../../core/errors/forbidden.exception.js';

export class DeleteProductMediaUseCase {
  constructor(
    private mediaRepo: ProductMediaRepository,
    private productRepo: ProductRepository,
    private supplierRepo: SupplierRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    mediaId: string,
    userId: string,
    userRole: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<boolean> {
    const media = await this.mediaRepo.findById(mediaId);
    if (!media) {
      throw new NotFoundException('Product media not found');
    }

    const product = await this.productRepo.findById(media.productId);
    if (!product) {
      throw new NotFoundException('Associated product not found');
    }

    const isAdmin = userRole === 'admin' || userRole === 'ADMIN';

    if (!isAdmin) {
      const supplier = await this.supplierRepo.findByUserId(userId);
      if (!supplier || product.supplierId !== supplier._id) {
        throw new ForbiddenException(
          'Access denied: You can only delete media from your own products.',
        );
      }
    }

    const success = await this.mediaRepo.delete(mediaId);

    if (success) {
      await this.securityLogRepo.logAction({
        _id: crypto.randomUUID(),
        userId,
        action: 'PRODUCT_MEDIA_DELETED',
        ipAddress,
        userAgent,
        metadata: { mediaId, productId: media.productId, url: media.url },
      });
    }

    return success;
  }
}
