import {
  VerificationRequestModel,
  IVerificationRequestDocument,
} from '../database/verification-request.schema.js';

export class VerificationRequestRepository {
  public async create(
    data: Partial<IVerificationRequestDocument>,
  ): Promise<IVerificationRequestDocument> {
    return await VerificationRequestModel.create(data);
  }

  public async findById(id: string): Promise<IVerificationRequestDocument | null> {
    return await VerificationRequestModel.findById(id);
  }

  public async findPendingRequests(): Promise<IVerificationRequestDocument[]> {
    return await VerificationRequestModel.find({ status: 'pending' }).sort({ createdAt: -1 });
  }

  public async updateStatus(
    id: string,
    status: 'pending' | 'verified' | 'rejected' | 'need_more_documents',
    reviewedBy: string,
    notes?: string,
  ): Promise<IVerificationRequestDocument | null> {
    return await VerificationRequestModel.findByIdAndUpdate(
      id,
      {
        status,
        reviewedBy,
        reviewedAt: new Date(),
        verificationNotes: notes,
      },
      { new: true },
    );
  }
}
