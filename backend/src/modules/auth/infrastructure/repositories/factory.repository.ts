import { FactoryModel, IFactoryDocument } from '../database/factory.schema.js';

export class FactoryRepository {
  public async create(data: Partial<IFactoryDocument>): Promise<IFactoryDocument> {
    return await FactoryModel.create(data);
  }

  public async findById(id: string): Promise<IFactoryDocument | null> {
    return await FactoryModel.findById(id);
  }

  public async findByUserId(userId: string): Promise<IFactoryDocument | null> {
    return await FactoryModel.findOne({ userId });
  }

  public async findByCommercialRegistration(cr: string): Promise<IFactoryDocument | null> {
    return await FactoryModel.findOne({ commercialRegistration: cr });
  }

  public async findByTaxNumber(taxNumber: string): Promise<IFactoryDocument | null> {
    return await FactoryModel.findOne({ taxNumber });
  }

  public async updateByUserId(
    userId: string,
    data: Partial<IFactoryDocument>,
  ): Promise<IFactoryDocument | null> {
    return await FactoryModel.findOneAndUpdate({ userId }, data, { new: true });
  }

  public async updateVerificationStatus(
    id: string,
    status: 'pending' | 'verified' | 'rejected' | 'need_more_documents',
    notes?: string,
  ): Promise<IFactoryDocument | null> {
    return await FactoryModel.findByIdAndUpdate(
      id,
      { verificationStatus: status, verificationNotes: notes },
      { new: true },
    );
  }
}
