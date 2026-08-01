import { SessionId } from '../value-objects/session-id.vo.js';
import { DeviceId } from '../../security/domain/value-objects/device-id.vo.js';

export enum SessionStatus {
  ACTIVE = 'Active',
  REVOKED = 'Revoked',
  EXPIRED = 'Expired',
}

export interface SessionProps {
  id: SessionId;
  userId: string;
  deviceId: DeviceId;
  status: SessionStatus;
  isRememberMe: boolean;
  ipAddress: string;
  userAgent: string;
  expiresAt: Date;
  lastActiveAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

export class Session {
  private props: SessionProps;

  private constructor(props: SessionProps) {
    this.props = props;
  }

  public static create(
    userId: string,
    deviceId: DeviceId,
    ipAddress: string,
    userAgent: string,
    isRememberMe = false,
    durationDays = 30,
  ): Session {
    const now = new Date();
    const expiresAt = new Date(now.getTime() + durationDays * 24 * 60 * 60 * 1000);
    return new Session({
      id: SessionId.create(),
      userId,
      deviceId,
      status: SessionStatus.ACTIVE,
      isRememberMe,
      ipAddress,
      userAgent,
      expiresAt,
      lastActiveAt: now,
      createdAt: now,
      updatedAt: now,
    });
  }

  public static reconstitute(props: SessionProps): Session {
    return new Session(props);
  }

  public get id(): SessionId {
    return this.props.id;
  }
  public get userId(): string {
    return this.props.userId;
  }
  public get deviceId(): DeviceId {
    return this.props.deviceId;
  }
  public get status(): SessionStatus {
    return this.props.status;
  }
  public get isRememberMe(): boolean {
    return this.props.isRememberMe;
  }
  public get ipAddress(): string {
    return this.props.ipAddress;
  }
  public get userAgent(): string {
    return this.props.userAgent;
  }
  public get expiresAt(): Date {
    return this.props.expiresAt;
  }
  public get lastActiveAt(): Date {
    return this.props.lastActiveAt;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt;
  }

  public isExpired(): boolean {
    return new Date() > this.props.expiresAt || this.props.status === SessionStatus.EXPIRED;
  }

  public isRevoked(): boolean {
    return this.props.status === SessionStatus.REVOKED;
  }

  public isValid(): boolean {
    return this.props.status === SessionStatus.ACTIVE && !this.isExpired();
  }

  public touch(): void {
    this.props.lastActiveAt = new Date();
    this.props.updatedAt = new Date();
  }

  public revoke(): void {
    this.props.status = SessionStatus.REVOKED;
    this.props.updatedAt = new Date();
  }
}
