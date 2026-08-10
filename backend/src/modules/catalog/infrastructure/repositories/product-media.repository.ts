import {
  ProductMediaModel,
  IProductMediaDocument,
} from '../database/product-media.schema.js';

export class ProductMediaRepository {
  public async findById(id: string): Promise<IProductMediaDocument | null> {
    return ProductMediaModel.findById(id).lean();
  }

  public async findByProductId(productId: string): Promise<IProductMediaDocument[]> {
    return ProductMediaModel.find({ productId }).sort({ sortOrder: 1, createdAt: 1 }).lean();
  }

  public async create(data: Partial<IProductMediaDocument>): Promise<IProductMediaDocument> {
    const doc = await ProductMediaModel.create(data);
    return doc.toObject();
  }

  public async delete(id: string): Promise<boolean> {
    const res = await ProductMediaModel.findByIdAndDelete(id);
    return Boolean(res);
  }

  public async deleteByProductId(productId: string): Promise<number> {
    const res = await ProductMediaModel.deleteMany({ productId });
    return res.deletedCount || 0;
  }

  public async clearPrimary(productId: string): Promise<void> {
    await ProductMediaModel.updateMany({ productId }, { $set: { isPrimary: false } });
  }

  public async setPrimary(id: string, productId: string): Promise<boolean> {
    await this.clearPrimary(productId);
    const res = await ProductMediaModel.findByIdAndUpdate(
      id,
      { $set: { isPrimary: true } },
      { new: true },
    );
    return Boolean(res);
  }

  public async updateSortOrder(items: Array<{ id: string; sortOrder: number }>): Promise<void> {
    const operations = items.map((item) => ({
      updateOne: {
        filter: { _id: item.id },
        update: { $set: { sortOrder: item.sortOrder } },
      },
    }));

    if (operations.length > 0) {
      await ProductMediaModel.bulkWrite(operations);
    }
  }
}
