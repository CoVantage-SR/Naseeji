import { SupplierModel, ISupplierDocument } from '../database/supplier.schema.js';

export class SupplierRepository {
  public async create(data: Partial<ISupplierDocument>): Promise<ISupplierDocument> {
    return await SupplierModel.create(data);
  }

  public async findById(id: string): Promise<ISupplierDocument | null> {
    return await SupplierModel.findById(id);
  }

  public async findByUserId(userId: string): Promise<ISupplierDocument | null> {
    return await SupplierModel.findOne({ userId });
  }

  public async findByCommercialRegistration(cr: string): Promise<ISupplierDocument | null> {
    return await SupplierModel.findOne({ commercialRegistration: cr });
  }

  public async findByTaxNumber(taxNumber: string): Promise<ISupplierDocument | null> {
    return await SupplierModel.findOne({ taxNumber });
  }

  public async updateByUserId(
    userId: string,
    data: Partial<ISupplierDocument>,
  ): Promise<ISupplierDocument | null> {
    return await SupplierModel.findOneAndUpdate({ userId }, data, { new: true });
  }

  public async updateVerificationStatus(
    id: string,
    status: 'pending' | 'verified' | 'rejected' | 'need_more_documents',
    notes?: string,
  ): Promise<ISupplierDocument | null> {
    return await SupplierModel.findByIdAndUpdate(
      id,
      { verificationStatus: status, verificationNotes: notes },
      { new: true },
    );
  }
}
