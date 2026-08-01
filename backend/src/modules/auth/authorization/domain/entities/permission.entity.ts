import { PermissionId } from '../value-objects/permission-id.vo.js';

export interface PermissionProps {
  id: PermissionId;
  code: string; // e.g. "rfq:create", "order:approve"
  group: string; // e.g. "RFQ", "ORDERS", "USERS"
  description: string;
  createdAt: Date;
}

export class Permission {
  private props: PermissionProps;

  private constructor(props: PermissionProps) {
    this.props = props;
  }

  public static create(code: string, group: string, description: string): Permission {
    return new Permission({
      id: PermissionId.create(),
      code: code.toLowerCase(),
      group: group.toUpperCase(),
      description,
      createdAt: new Date(),
    });
  }

  public static reconstitute(props: PermissionProps): Permission {
    return new Permission(props);
  }

  public get id(): PermissionId {
    return this.props.id;
  }
  public get code(): string {
    return this.props.code;
  }
  public get group(): string {
    return this.props.group;
  }
  public get description(): string {
    return this.props.description;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
}
