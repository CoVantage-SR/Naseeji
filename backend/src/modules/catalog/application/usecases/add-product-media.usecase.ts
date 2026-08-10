import crypto from 'crypto';
import { ProductMediaRepository } from '../../infrastructure/repositories/product-media.repository.js';
import { ProductRepository } from '../../infrastructure/repositories/product.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { AddProductMediaDto } from '../dtos/product-media.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';
import { ForbiddenException } from '../../../../core/errors/forbidden.exception.js';
import { IProductMediaDocument } from '../../infrastructure/database/product-media.schema.js';

export class AddProductMediaUseCase {
  constructor(
    private mediaRepo: ProductMediaRepository,
    private productRepo: ProductRepository,
    private supplierRepo: SupplierRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    userId: string,
    userRole: string,
    dto: AddProductMediaDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<IProductMediaDocument> {
    const product = await this.productRepo.findById(dto.productId);
    if (!product || product.status === 'archived') {
      throw new NotFoundException('Product not found');
    }

    const isAdmin = userRole === 'admin' || userRole === 'ADMIN';

    if (!isAdmin) {
      const supplier = await this.supplierRepo.findByUserId(userId);
      if (!supplier || product.supplierId !== supplier._id) {
        throw new ForbiddenException(
          'Access denied: You can only add media to your own products.',
        );
      }
    }

    // Environmental configuration limits
    const maxImageSizeMb = Number(process.env.MAX_PRODUCT_IMAGE_SIZE_MB || '5');
    const maxVideoSizeMb = Number(process.env.MAX_PRODUCT_VIDEO_SIZE_MB || '50');
    const maxDocumentSizeMb = Number(process.env.MAX_PRODUCT_DOCUMENT_SIZE_MB || '10');
    const maxVideoDurationSeconds = Number(
      process.env.MAX_PRODUCT_VIDEO_DURATION_SECONDS || '120',
    );

    const fileSizeMb = dto.fileSize / (1024 * 1024);

    if (dto.type === 'image') {
      if (!dto.mimeType.startsWith('image/')) {
        throw new BusinessException(`Invalid image MIME type: ${dto.mimeType}`);
      }
      if (fileSizeMb > maxImageSizeMb) {
        throw new BusinessException(
          `Image file size exceeds maximum limit of ${maxImageSizeMb} MB.`,
        );
      }
    } else if (dto.type === 'video') {
      if (!dto.mimeType.startsWith('video/')) {
        throw new BusinessException(`Invalid video MIME type: ${dto.mimeType}`);
      }
      if (fileSizeMb > maxVideoSizeMb) {
        throw new BusinessException(
          `Video file size exceeds maximum limit of ${maxVideoSizeMb} MB.`,
        );
      }
      if (dto.duration && dto.duration > maxVideoDurationSeconds) {
        throw new BusinessException(
          `Video duration exceeds maximum allowed duration of ${maxVideoDurationSeconds} seconds.`,
        );
      }
    } else if (dto.type === 'document') {
      if (
        !dto.mimeType.includes('pdf') &&
        !dto.mimeType.includes('document') &&
        !dto.mimeType.includes('msword')
      ) {
        throw new BusinessException(`Invalid document MIME type: ${dto.mimeType}`);
      }
      if (fileSizeMb > maxDocumentSizeMb) {
        throw new BusinessException(
          `Document file size exceeds maximum limit of ${maxDocumentSizeMb} MB.`,
        );
      }
    }

    if (dto.isPrimary) {
      await this.mediaRepo.clearPrimary(dto.productId);
    }

    const mediaDoc = await this.mediaRepo.create({
      _id: crypto.randomUUID(),
      productId: dto.productId,
      type: dto.type,
      url: dto.url,
      thumbnailUrl: dto.thumbnailUrl,
      fileSize: dto.fileSize,
      mimeType: dto.mimeType,
      duration: dto.duration,
      sortOrder: dto.sortOrder ?? 0,
      isPrimary: Boolean(dto.isPrimary),
    });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'PRODUCT_MEDIA_UPLOADED',
      ipAddress,
      userAgent,
      metadata: {
        mediaId: mediaDoc._id,
        productId: dto.productId,
        type: dto.type,
        url: dto.url,
      },
    });

    return mediaDoc;
  }
}
