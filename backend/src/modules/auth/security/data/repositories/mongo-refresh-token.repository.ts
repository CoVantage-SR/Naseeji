import { IRefreshTokenRepository } from '../../domain/repositories/refresh-token.repository.interface.js';
import { RefreshTokenEntity } from '../../domain/entities/refresh-token.entity.js';
import { RefreshTokenModel } from '../models/refresh-token.model.js';
import { RefreshTokenMapper } from '../mappers/refresh-token.mapper.js';

export class MongoRefreshTokenRepository implements IRefreshTokenRepository {
  public async save(token: RefreshTokenEntity): Promise<void> {
    const raw = RefreshTokenMapper.toPersistence(token);
    await RefreshTokenModel.findByIdAndUpdate(token.id, raw, { upsert: true, new: true });
  }

  public async findByJti(jti: string): Promise<RefreshTokenEntity | null> {
    const doc = await RefreshTokenModel.findOne({ jti });
    return doc ? RefreshTokenMapper.toDomain(doc) : null;
  }

  public async revokeByJti(jti: string): Promise<void> {
    await RefreshTokenModel.findOneAndUpdate({ jti }, { isRevoked: true });
  }

  public async revokeFamily(tokenFamilyId: string): Promise<void> {
    await RefreshTokenModel.updateMany({ tokenFamilyId }, { isRevoked: true });
  }

  public async revokeAllSessionTokens(sessionId: string): Promise<void> {
    await RefreshTokenModel.updateMany({ sessionId }, { isRevoked: true });
  }
}
