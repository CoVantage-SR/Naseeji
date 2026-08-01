import { RefreshToken } from '../value-objects/refresh-token.vo.js';

export interface RefreshTokenProps {
  id: string;
  jti: string;
  token: RefreshToken;
  sessionId: string;
  userId: string;
  tokenFamilyId: string;
  isUsed: boolean;
  isRevoked: boolean;
  expiresAt: Date;
  createdAt: Date;
}

export class RefreshTokenEntity {
  private props: RefreshTokenProps;

  private constructor(props: RefreshTokenProps) {
    this.props = props;
  }

  public static create(
    id: string,
    jti: string,
    rawToken: string,
    sessionId: string,
    userId: string,
    tokenFamilyId: string,
    durationDays = 30,
  ): RefreshTokenEntity {
    const now = new Date();
    const expiresAt = new Date(now.getTime() + durationDays * 24 * 60 * 60 * 1000);
    return new RefreshTokenEntity({
      id,
      jti,
      token: new RefreshToken(rawToken, jti),
      sessionId,
      userId,
      tokenFamilyId,
      isUsed: false,
      isRevoked: false,
      expiresAt,
      createdAt: now,
    });
  }

  public static reconstitute(props: RefreshTokenProps): RefreshTokenEntity {
    return new RefreshTokenEntity(props);
  }

  public get id(): string {
    return this.props.id;
  }
  public get jti(): string {
    return this.props.jti;
  }
  public get token(): RefreshToken {
    return this.props.token;
  }
  public get sessionId(): string {
    return this.props.sessionId;
  }
  public get userId(): string {
    return this.props.userId;
  }
  public get tokenFamilyId(): string {
    return this.props.tokenFamilyId;
  }
  public get isUsed(): boolean {
    return this.props.isUsed;
  }
  public get isRevoked(): boolean {
    return this.props.isRevoked;
  }
  public get expiresAt(): Date {
    return this.props.expiresAt;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }

  public markUsed(): void {
    this.props.isUsed = true;
  }

  public revoke(): void {
    this.props.isRevoked = true;
  }

  public isValid(): boolean {
    return !this.props.isUsed && !this.props.isRevoked && new Date() < this.props.expiresAt;
  }
}
