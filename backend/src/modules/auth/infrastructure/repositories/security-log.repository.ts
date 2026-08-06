import { SecurityLogModel, ISecurityLogDocument } from '../database/security-log.schema.js';

export class SecurityLogRepository {
  public async logAction(data: Partial<ISecurityLogDocument>): Promise<ISecurityLogDocument> {
    return await SecurityLogModel.create(data);
  }

  public async findByUserId(userId: string, limit: number = 50): Promise<ISecurityLogDocument[]> {
    return await SecurityLogModel.find({ userId }).sort({ createdAt: -1 }).limit(limit);
  }
}
