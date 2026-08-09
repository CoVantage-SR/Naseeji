import jwt from 'jsonwebtoken';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface TokenPayload {
  sub: string;
  sessionId?: string;
  accountType?: string;
  role?: string;
  roles?: string[];
  email?: string;
  phone?: string;
  jti?: string;
}

export interface AccessTokenPayload extends TokenPayload {
  sub: string;
  role: string;
  sessionId: string;
}

export interface IssuedTokens {
  accessToken: string;
  refreshToken: string;
  jti: string;
  accessTokenExpiresIn: number;
  refreshTokenExpiresIn: number;
}

/**
 * JwtService — signs access tokens with JWT_SECRET and refresh tokens with JWT_REFRESH_SECRET.
 * Token TTL is driven by environment: JWT_ACCESS_TTL (default 15m) and JWT_REFRESH_TTL (default 30d).
 */
export class JwtService {
  private readonly accessSecret: string;
  private readonly refreshSecret: string;
  private readonly accessTokenTtl: string;
  private readonly refreshTokenTtl: string;

  constructor() {
    this.accessSecret = process.env.JWT_SECRET || 'naseeji-enterprise-super-secret-jwt-key-2026';
    this.refreshSecret =
      process.env.JWT_REFRESH_SECRET || 'naseeji-enterprise-super-secret-refresh-key-2026';
    this.accessTokenTtl = process.env.JWT_ACCESS_TTL || '15m';
    this.refreshTokenTtl = process.env.JWT_REFRESH_TTL || '30d';
  }

  /**
   * Returns the number of seconds until the access token expires, parsed from the TTL string.
   */
  public get accessTokenExpirySeconds(): number {
    return this._parseTtlToSeconds(this.accessTokenTtl);
  }

  /**
   * Returns the number of seconds until the refresh token expires.
   */
  public get refreshTokenExpirySeconds(): number {
    return this._parseTtlToSeconds(this.refreshTokenTtl);
  }

  /**
   * Issues a new access token + refresh token pair.
   * Access token is signed with JWT_SECRET; refresh token with JWT_REFRESH_SECRET.
   */
  public issueTokens(
    userId: string,
    sessionId: string,
    role: string,
    roles: string[],
  ): IssuedTokens {
    const jti = UuidUtil.generate();
    const accessPayload: AccessTokenPayload = {
      sub: userId,
      sessionId,
      role,
      roles,
      accountType: role,
    };

    const accessToken = jwt.sign(accessPayload, this.accessSecret, {
      expiresIn: this.accessTokenTtl as jwt.SignOptions['expiresIn'],
    });

    const refreshToken = jwt.sign({ sub: userId, sessionId, jti }, this.refreshSecret, {
      expiresIn: this.refreshTokenTtl as jwt.SignOptions['expiresIn'],
    });

    return {
      accessToken,
      refreshToken,
      jti,
      accessTokenExpiresIn: this.accessTokenExpirySeconds,
      refreshTokenExpiresIn: this.refreshTokenExpirySeconds,
    };
  }

  /**
   * Verifies an access token using JWT_SECRET.
   */
  public verifyToken<T extends TokenPayload>(token: string): T {
    return jwt.verify(token, this.accessSecret) as T;
  }

  /**
   * Verifies a refresh token using JWT_REFRESH_SECRET.
   */
  public verifyRefreshToken<T extends TokenPayload>(token: string): T {
    return jwt.verify(token, this.refreshSecret) as T;
  }

  private _parseTtlToSeconds(ttl: string): number {
    const match = ttl.match(/^(\d+)([smhd])$/);
    if (!match || match.length < 3) return 900; // default 15 minutes
    const value = parseInt(match[1]!, 10);
    const unit = match[2]! as 's' | 'm' | 'h' | 'd';
    const multipliers: Record<'s' | 'm' | 'h' | 'd', number> = {
      s: 1,
      m: 60,
      h: 3600,
      d: 86400,
    };
    return value * (multipliers[unit] ?? 60);
  }
}
