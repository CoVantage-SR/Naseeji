import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { IBrandDocument } from '../../infrastructure/database/brand.schema.js';

export class ListBrandsUseCase {
  constructor(private brandRepo: BrandRepository) {}

  public async execute(
    filters: Record<string, any> = {},
    page = 1,
    limit = 50,
  ): Promise<{ items: IBrandDocument[]; total: number }> {
    return this.brandRepo.list(filters, page, limit);
  }
}
