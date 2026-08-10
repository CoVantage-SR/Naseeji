import crypto from 'crypto';
import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

export class DeleteCategoryUseCase {
  constructor(
    private categoryRepo: CategoryRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    categoryId: string,
    userId: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<boolean> {
    const category = await this.categoryRepo.findById(categoryId);
    if (!category || category.status === 'archived') {
      throw new NotFoundException('Category not found');
    }

    const success = await this.categoryRepo.delete(categoryId);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'CATEGORY_DELETED',
      ipAddress,
      userAgent,
      metadata: { categoryId, name: category.name },
    });

    return success;
  }
}
