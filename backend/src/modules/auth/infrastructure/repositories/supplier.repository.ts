import mongoose from 'mongoose';
import { SupplierModel, ISupplierDocument } from '../database/supplier.schema.js';

export class SupplierRepository {
  public async create(data: Partial<ISupplierDocument>): Promise<ISupplierDocument> {
    if (mongoose.connection.readyState !== 1) return data as ISupplierDocument;
    return await SupplierModel.create(data);
  }

  public async findById(id: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findById(id);
  }

  public async findByUserId(userId: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOne({ userId });
  }

  public async findByCommercialRegistration(cr: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOne({ commercialRegistration: cr });
  }

  public async findByTaxNumber(tax: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOne({ taxNumber: tax });
  }

  public async updateByUserId(
    userId: string,
    updates: Partial<ISupplierDocument>,
  ): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return updates as ISupplierDocument;
    return await SupplierModel.findOneAndUpdate({ userId }, updates, { new: true });
  }

  public async updateVerificationStatus(
    userId: string,
    status: 'verified' | 'rejected' | 'pending',
    notes?: string,
  ): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOneAndUpdate(
      { userId },
      { verificationStatus: status, verificationNotes: notes },
      { new: true },
    );
  }
}
