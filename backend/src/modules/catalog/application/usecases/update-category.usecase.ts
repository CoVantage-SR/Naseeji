import crypto from 'crypto';
import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { UpdateCategoryDto } from '../dtos/category.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { ICategoryDocument } from '../../infrastructure/database/category.schema.js';

export class UpdateCategoryUseCase {
  constructor(
    private categoryRepo: CategoryRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    categoryId: string,
    userId: string,
    dto: UpdateCategoryDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<ICategoryDocument> {
    const category = await this.categoryRepo.findById(categoryId);
    if (!category || category.status === 'archived') {
      throw new NotFoundException('Category not found');
    }

    const updates: Partial<ICategoryDocument> = {};

    if (dto.name && dto.name !== category.name) {
      updates.name = dto.name;
      updates.slug = await SlugUtil.generateUniqueSlug(dto.name, async (s) => {
        const existing = await this.categoryRepo.findBySlug(s);
        return Boolean(existing && existing._id !== categoryId);
      });
    }

    if (dto.description !== undefined) updates.description = dto.description;
    if (dto.image !== undefined) updates.image = dto.image;
    if (dto.sortOrder !== undefined) updates.sortOrder = dto.sortOrder;
    if (dto.isFeatured !== undefined) updates.isFeatured = dto.isFeatured;
    if (dto.status !== undefined) updates.status = dto.status;

    if (dto.parentId !== undefined && dto.parentId !== category.parentId) {
      if (dto.parentId === categoryId) {
        throw new BusinessException('A category cannot be its own parent.');
      }

      if (dto.parentId) {
        const parent = await this.categoryRepo.findById(dto.parentId);
        if (!parent || parent.status === 'archived') {
          throw new NotFoundException('Parent category not found');
        }

        // Circular hierarchy check: ensure categoryId is not in parent's ancestor chain
        const parentAncestors = await this.categoryRepo.getAncestors(dto.parentId);
        if (parentAncestors.some((ancestor) => ancestor._id === categoryId)) {
          throw new BusinessException(
            'Invalid parent category: Circular parent relationship detected.',
          );
        }

        updates.parentId = parent._id;
        updates.level = parent.level + 1;
      } else {
        updates.parentId = null;
        updates.level = 0;
      }
    }

    const updated = await this.categoryRepo.update(categoryId, updates);
    if (!updated) {
      throw new NotFoundException('Category not found for update');
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'CATEGORY_UPDATED',
      ipAddress,
      userAgent,
      metadata: { categoryId: updated._id, updates },
    });

    return updated;
  }
}
