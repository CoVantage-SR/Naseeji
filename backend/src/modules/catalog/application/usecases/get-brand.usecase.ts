import { BrandRepository } from '../../infrastructure/repositories/brand.repository.js';
import { IBrandDocument } from '../../infrastructure/database/brand.schema.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

export class GetBrandUseCase {
  constructor(private brandRepo: BrandRepository) {}

  public async getById(id: string): Promise<IBrandDocument> {
    const brand = await this.brandRepo.findById(id);
    if (!brand || brand.status === 'archived') {
      throw new NotFoundException('Brand not found');
    }
    return brand;
  }

  public async getBySlug(slug: string): Promise<IBrandDocument> {
    const brand = await this.brandRepo.findBySlug(slug);
    if (!brand || brand.status === 'archived') {
      throw new NotFoundException('Brand not found');
    }
    return brand;
  }
}
