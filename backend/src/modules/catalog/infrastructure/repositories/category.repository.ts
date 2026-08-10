import { CategoryModel, ICategoryDocument } from '../database/category.schema.js';

export class CategoryRepository {
  public async findById(id: string): Promise<ICategoryDocument | null> {
    return CategoryModel.findById(id).lean();
  }

  public async findBySlug(slug: string): Promise<ICategoryDocument | null> {
    return CategoryModel.findOne({ slug }).lean();
  }

  public async findByName(name: string): Promise<ICategoryDocument | null> {
    return CategoryModel.findOne({ name: { $regex: new RegExp(`^${name}$`, 'i') } }).lean();
  }

  public async create(data: Partial<ICategoryDocument>): Promise<ICategoryDocument> {
    const doc = await CategoryModel.create(data);
    return doc.toObject();
  }

  public async update(
    id: string,
    data: Partial<ICategoryDocument>,
  ): Promise<ICategoryDocument | null> {
    return CategoryModel.findByIdAndUpdate(id, { $set: data }, { new: true }).lean();
  }

  public async delete(id: string): Promise<boolean> {
    const res = await CategoryModel.findByIdAndUpdate(id, { $set: { status: 'archived' } });
    return Boolean(res);
  }

  public async list(
    filter: Record<string, any> = {},
    page = 1,
    limit = 20,
  ): Promise<{ items: ICategoryDocument[]; total: number }> {
    const skip = (page - 1) * limit;
    const query = { status: { $ne: 'archived' }, ...filter };

    const [items, total] = await Promise.all([
      CategoryModel.find(query).sort({ sortOrder: 1, name: 1 }).skip(skip).limit(limit).lean(),
      CategoryModel.countDocuments(query),
    ]);

    return { items, total };
  }

  public async getTree(): Promise<ICategoryDocument[]> {
    const categories = await CategoryModel.find({ status: { $ne: 'archived' } })
      .sort({ level: 1, sortOrder: 1, name: 1 })
      .lean();

    return categories;
  }

  public async getAncestors(categoryId: string): Promise<ICategoryDocument[]> {
    const ancestors: ICategoryDocument[] = [];
    let currentId: string | null | undefined = categoryId;

    while (currentId) {
      const parent = await CategoryModel.findById(currentId).lean();
      if (!parent) break;
      ancestors.push(parent);
      currentId = parent.parentId;
    }

    return ancestors;
  }

  public async incrementProductCount(id: string, delta: number): Promise<void> {
    await CategoryModel.findByIdAndUpdate(id, { $inc: { productCount: delta } });
  }
}
