import { CategoryRepository } from '../../infrastructure/repositories/category.repository.js';
import { ICategoryDocument } from '../../infrastructure/database/category.schema.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

export class GetCategoryUseCase {
  constructor(private categoryRepo: CategoryRepository) {}

  public async getById(id: string): Promise<ICategoryDocument> {
    const category = await this.categoryRepo.findById(id);
    if (!category || category.status === 'archived') {
      throw new NotFoundException('Category not found');
    }
    return category;
  }

  public async getBySlug(slug: string): Promise<ICategoryDocument> {
    const category = await this.categoryRepo.findBySlug(slug);
    if (!category || category.status === 'archived') {
      throw new NotFoundException('Category not found');
    }
    return category;
  }
}
