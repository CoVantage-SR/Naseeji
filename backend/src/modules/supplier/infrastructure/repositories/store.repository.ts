import mongoose from 'mongoose';
import { StoreModel, IStoreDocument, StoreStatusType } from '../database/store.schema.js';

export class StoreRepository {
  public async create(data: Partial<IStoreDocument>): Promise<IStoreDocument> {
    if (mongoose.connection.readyState !== 1) return data as IStoreDocument;
    return await StoreModel.create(data);
  }

  public async findById(id: string): Promise<IStoreDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await StoreModel.findById(id);
  }

  public async findBySupplierId(supplierId: string): Promise<IStoreDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await StoreModel.findOne({ supplierId });
  }

  public async findBySlug(slug: string): Promise<IStoreDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await StoreModel.findOne({ slug });
  }

  public async updateBySupplierId(
    supplierId: string,
    updates: Partial<IStoreDocument>,
  ): Promise<IStoreDocument | null> {
    if (mongoose.connection.readyState !== 1) return updates as IStoreDocument;
    return await StoreModel.findOneAndUpdate({ supplierId }, updates, { new: true });
  }

  public async updateStatus(
    supplierId: string,
    status: StoreStatusType,
  ): Promise<IStoreDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await StoreModel.findOneAndUpdate({ supplierId }, { status }, { new: true });
  }

  public async deleteBySupplierId(supplierId: string): Promise<boolean> {
    if (mongoose.connection.readyState !== 1) return true;
    const res = await StoreModel.deleteOne({ supplierId });
    return res.deletedCount > 0;
  }
}
