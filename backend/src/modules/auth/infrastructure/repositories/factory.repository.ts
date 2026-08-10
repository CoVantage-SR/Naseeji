import mongoose from 'mongoose';
import { FactoryModel, IFactoryDocument } from '../database/factory.schema.js';

export class FactoryRepository {
  public async create(data: Partial<IFactoryDocument>): Promise<IFactoryDocument> {
    if (mongoose.connection.readyState !== 1) return data as IFactoryDocument;
    return await FactoryModel.create(data);
  }

  public async findById(id: string): Promise<IFactoryDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await FactoryModel.findById(id);
  }

  public async findByUserId(userId: string): Promise<IFactoryDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await FactoryModel.findOne({ userId });
  }

  public async findByCommercialRegistration(cr: string): Promise<IFactoryDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await FactoryModel.findOne({ commercialRegistration: cr });
  }

  public async findByTaxNumber(tax: string): Promise<IFactoryDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await FactoryModel.findOne({ taxNumber: tax });
  }

  public async updateByUserId(
    userId: string,
    updates: Partial<IFactoryDocument>,
  ): Promise<IFactoryDocument | null> {
    if (mongoose.connection.readyState !== 1) return updates as IFactoryDocument;
    return await FactoryModel.findOneAndUpdate({ userId }, updates, { new: true });
  }

  public async updateVerificationStatus(
    userId: string,
    status: 'verified' | 'rejected' | 'pending' | 'need_more_documents',
    notes?: string,
  ): Promise<IFactoryDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await FactoryModel.findOneAndUpdate(
      { userId },
      { verificationStatus: status, verificationNotes: notes },
      { new: true },
    );
  }
}
