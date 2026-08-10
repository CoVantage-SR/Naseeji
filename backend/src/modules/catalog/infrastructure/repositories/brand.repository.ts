import { BrandModel, IBrandDocument } from '../database/brand.schema.js';

export class BrandRepository {
  public async findById(id: string): Promise<IBrandDocument | null> {
    return BrandModel.findById(id).lean();
  }

  public async findBySlug(slug: string): Promise<IBrandDocument | null> {
    return BrandModel.findOne({ slug }).lean();
  }

  public async create(data: Partial<IBrandDocument>): Promise<IBrandDocument> {
    const doc = await BrandModel.create(data);
    return doc.toObject();
  }

  public async update(
    id: string,
    data: Partial<IBrandDocument>,
  ): Promise<IBrandDocument | null> {
    return BrandModel.findByIdAndUpdate(id, { $set: data }, { new: true }).lean();
  }

  public async delete(id: string): Promise<boolean> {
    const res = await BrandModel.findByIdAndUpdate(id, { $set: { status: 'archived' } });
    return Boolean(res);
  }

  public async list(
    filter: Record<string, any> = {},
    page = 1,
    limit = 20,
  ): Promise<{ items: IBrandDocument[]; total: number }> {
    const skip = (page - 1) * limit;
    const query = { status: { $ne: 'archived' }, ...filter };

    const [items, total] = await Promise.all([
      BrandModel.find(query).sort({ name: 1 }).skip(skip).limit(limit).lean(),
      BrandModel.countDocuments(query),
    ]);

    return { items, total };
  }
}
