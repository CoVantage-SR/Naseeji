export type SecurityAction =
  | 'login_success'
  | 'login_failure'
  | 'logout'
  | 'logout_all'
  | 'password_change'
  | 'password_reset_request'
  | 'password_reset_success'
  | 'account_deactivated'
  | 'account_deleted'
  | 'otp_requested'
  | 'otp_verified'
  | 'token_refreshed'
  | 'token_reuse_detected'
  | 'verification_updated';

export interface SecurityLogProps {
  id: string;
  userId?: string;
  action: SecurityAction;
  ipAddress: string;
  userAgent: string;
  device?: string;
  browser?: string;
  country?: string;
  metadata?: Record<string, any>;
  createdAt: Date;
}

export class SecurityLog {
  private props: SecurityLogProps;

  constructor(props: SecurityLogProps) {
    this.props = props;
  }

  public get id(): string {
    return this.props.id;
  }
  public get userId(): string | undefined {
    return this.props.userId;
  }
  public get action(): SecurityAction {
    return this.props.action;
  }
  public get ipAddress(): string {
    return this.props.ipAddress;
  }
  public get userAgent(): string {
    return this.props.userAgent;
  }
  public get device(): string | undefined {
    return this.props.device;
  }
  public get browser(): string | undefined {
    return this.props.browser;
  }
  public get country(): string | undefined {
    return this.props.country;
  }
  public get metadata(): Record<string, any> | undefined {
    return this.props.metadata;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }

  public toJSON() {
    return { ...this.props };
  }
}
