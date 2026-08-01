import { IRefreshTokenDocument } from '../models/refresh-token.model.js';
import { RefreshTokenEntity } from '../../domain/entities/refresh-token.entity.js';
import { RefreshToken } from '../../domain/value-objects/refresh-token.vo.js';

export class RefreshTokenMapper {
  public static toDomain(doc: IRefreshTokenDocument): RefreshTokenEntity {
    return RefreshTokenEntity.reconstitute({
      id: doc._id,
      jti: doc.jti,
      token: new RefreshToken(doc.token, doc.jti),
      sessionId: doc.sessionId,
      userId: doc.userId,
      tokenFamilyId: doc.tokenFamilyId,
      isUsed: doc.isUsed,
      isRevoked: doc.isRevoked,
      expiresAt: doc.expiresAt,
      createdAt: doc.createdAt,
    });
  }

  public static toPersistence(entity: RefreshTokenEntity): Record<string, unknown> {
    return {
      _id: entity.id,
      jti: entity.jti,
      token: entity.token.token,
      sessionId: entity.sessionId,
      userId: entity.userId,
      tokenFamilyId: entity.tokenFamilyId,
      isUsed: entity.isUsed,
      isRevoked: entity.isRevoked,
      expiresAt: entity.expiresAt,
    };
  }
}
