import crypto from 'crypto';
import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { CreateCategoryDto } from '../dtos/category.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';
import { SlugUtil } from '../../../../shared/utils/slug.util.js';
import { ICategoryDocument } from '../../infrastructure/database/category.schema.js';

export class CreateCategoryUseCase {
  constructor(
    private categoryRepo: CategoryRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    userId: string,
    dto: CreateCategoryDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<ICategoryDocument> {
    let level = 0;
    let parentId: string | null = null;

    if (dto.parentId) {
      const parent = await this.categoryRepo.findById(dto.parentId);
      if (!parent || parent.status === 'archived') {
        throw new NotFoundException('Parent category not found');
      }
      level = parent.level + 1;
      parentId = parent._id;
    }

    const slug = await SlugUtil.generateUniqueSlug(dto.name, async (s) => {
      const existing = await this.categoryRepo.findBySlug(s);
      return Boolean(existing);
    });

    const category = await this.categoryRepo.create({
      _id: crypto.randomUUID(),
      name: dto.name,
      slug,
      description: dto.description,
      image: dto.image,
      parentId,
      level,
      status: dto.status || 'active',
      sortOrder: dto.sortOrder ?? 0,
      isFeatured: dto.isFeatured ?? false,
      productCount: 0,
    });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'CATEGORY_CREATED',
      ipAddress,
      userAgent,
      metadata: { categoryId: category._id, name: category.name, slug: category.slug },
    });

    return category;
  }
}
