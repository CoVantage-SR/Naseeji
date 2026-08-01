import { RefreshTokenEntity } from '../entities/refresh-token.entity.js';

export interface IRefreshTokenRepository {
  save(token: RefreshTokenEntity): Promise<void>;
  findByJti(jti: string): Promise<RefreshTokenEntity | null>;
  revokeByJti(jti: string): Promise<void>;
  revokeFamily(tokenFamilyId: string): Promise<void>;
  revokeAllSessionTokens(sessionId: string): Promise<void>;
}
