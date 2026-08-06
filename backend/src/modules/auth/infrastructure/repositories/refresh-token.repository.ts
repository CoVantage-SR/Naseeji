import { RefreshTokenModel, IRefreshTokenDocument } from '../database/refresh-token.schema.js';

export class RefreshTokenRepository {
  public async create(data: Partial<IRefreshTokenDocument>): Promise<IRefreshTokenDocument> {
    return await RefreshTokenModel.create(data);
  }

  public async findByHash(tokenHash: string): Promise<IRefreshTokenDocument | null> {
    return await RefreshTokenModel.findOne({ tokenHash });
  }

  public async markAsUsed(id: string): Promise<void> {
    await RefreshTokenModel.updateOne({ _id: id }, { isUsed: true });
  }

  public async revokeFamily(familyId: string): Promise<number> {
    const res = await RefreshTokenModel.updateMany(
      { familyId, isRevoked: false },
      { isRevoked: true },
    );
    return res.modifiedCount;
  }

  public async revokeAllForSession(sessionId: string): Promise<number> {
    const res = await RefreshTokenModel.updateMany(
      { sessionId, isRevoked: false },
      { isRevoked: true },
    );
    return res.modifiedCount;
  }

  public async revokeAllForUser(userId: string): Promise<number> {
    const res = await RefreshTokenModel.updateMany(
      { userId, isRevoked: false },
      { isRevoked: true },
    );
    return res.modifiedCount;
  }
}
