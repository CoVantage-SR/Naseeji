import { SessionModel, ISessionDocument } from '../database/session.schema.js';

export class SessionRepository {
  public async create(data: Partial<ISessionDocument>): Promise<ISessionDocument> {
    return await SessionModel.create(data);
  }

  public async findById(id: string): Promise<ISessionDocument | null> {
    return await SessionModel.findById(id);
  }

  public async findActiveByUserId(userId: string): Promise<ISessionDocument[]> {
    return await SessionModel.find({
      userId,
      isRevoked: false,
      expiresAt: { $gt: new Date() },
    }).sort({ lastActiveAt: -1 });
  }

  public async revokeById(id: string, userId: string): Promise<boolean> {
    const res = await SessionModel.updateOne({ _id: id, userId }, { isRevoked: true });
    return res.modifiedCount > 0;
  }

  public async revokeAllUserSessions(userId: string): Promise<number> {
    const res = await SessionModel.updateMany({ userId, isRevoked: false }, { isRevoked: true });
    return res.modifiedCount;
  }

  public async touchSession(id: string): Promise<void> {
    await SessionModel.updateOne({ _id: id }, { lastActiveAt: new Date() });
  }
}
