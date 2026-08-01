import { AuditAction } from '../value-objects/audit-action.enum.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface AuditLogProps {
  id: string;
  userId?: string;
  action: AuditAction;
  ipAddress: string;
  userAgent: string;
  traceId: string;
  metadata?: Record<string, unknown>;
  createdAt: Date;
}

export class AuditLog {
  private props: AuditLogProps;

  private constructor(props: AuditLogProps) {
    this.props = props;
  }

  public static create(
    action: AuditAction,
    ipAddress: string,
    userAgent: string,
    traceId: string,
    userId?: string,
    metadata?: Record<string, unknown>,
  ): AuditLog {
    return new AuditLog({
      id: UuidUtil.generate(),
      userId,
      action,
      ipAddress,
      userAgent,
      traceId,
      metadata,
      createdAt: new Date(),
    });
  }

  public static reconstitute(props: AuditLogProps): AuditLog {
    return new AuditLog(props);
  }

  public get id(): string {
    return this.props.id;
  }
  public get userId(): string | undefined {
    return this.props.userId;
  }
  public get action(): AuditAction {
    return this.props.action;
  }
  public get ipAddress(): string {
    return this.props.ipAddress;
  }
  public get userAgent(): string {
    return this.props.userAgent;
  }
  public get traceId(): string {
    return this.props.traceId;
  }
  public get metadata(): Record<string, unknown> | undefined {
    return this.props.metadata;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
}
