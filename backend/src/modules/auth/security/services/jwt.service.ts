import jwt from 'jsonwebtoken';
import { UuidUtil } from '../../../../core/utils/uuid.util.js';

export interface TokenPayload {
  sub: string; // User ID
  sessionId: string;
  accountType: string;
  roles: string[];
  jti?: string;
}

export interface IssuedTokens {
  accessToken: string;
  refreshToken: string;
  jti: string;
  accessTokenExpiresIn: number;
  refreshTokenExpiresIn: number;
}

export class JwtService {
  private readonly secret: string;
  private readonly accessTokenExpirySeconds: number;
  private readonly refreshTokenExpirySeconds: number;

  constructor(
    secret = process.env.JWT_SECRET || 'naseeji-super-secret-jwt-key-2026',
    accessTokenExpirySeconds = 900, // 15 mins
    refreshTokenExpirySeconds = 2592000, // 30 days
  ) {
    this.secret = secret;
    this.accessTokenExpirySeconds = accessTokenExpirySeconds;
    this.refreshTokenExpirySeconds = refreshTokenExpirySeconds;
  }

  public issueTokens(
    userId: string,
    sessionId: string,
    accountType: string,
    roles: string[],
  ): IssuedTokens {
    const jti = UuidUtil.generate();
    const payload: TokenPayload = {
      sub: userId,
      sessionId,
      accountType,
      roles,
    };

    const accessToken = jwt.sign(payload, this.secret, {
      expiresIn: this.accessTokenExpirySeconds,
    });

    const refreshToken = jwt.sign({ ...payload, jti }, this.secret, {
      expiresIn: this.refreshTokenExpirySeconds,
    });

    return {
      accessToken,
      refreshToken,
      jti,
      accessTokenExpiresIn: this.accessTokenExpirySeconds,
      refreshTokenExpiresIn: this.refreshTokenExpirySeconds,
    };
  }

  public verifyToken<T extends TokenPayload>(token: string): T {
    return jwt.verify(token, this.secret) as T;
  }
}
