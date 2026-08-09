import mongoose from 'mongoose';
import { SecurityLogModel, ISecurityLogDocument } from '../database/security-log.schema.js';

export class SecurityLogRepository {
  public async logAction(data: Partial<ISecurityLogDocument>): Promise<ISecurityLogDocument> {
    if (mongoose.connection.readyState !== 1) return data as ISecurityLogDocument;
    return await SecurityLogModel.create(data);
  }

  public async findByUserId(userId: string, limit = 50): Promise<ISecurityLogDocument[]> {
    if (mongoose.connection.readyState !== 1) return [];
    return await SecurityLogModel.find({ userId }).sort({ createdAt: -1 }).limit(limit);
  }
}
