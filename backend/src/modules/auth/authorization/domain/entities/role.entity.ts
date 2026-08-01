import { RoleId } from '../value-objects/role-id.vo.js';

export interface RoleProps {
  id: RoleId;
  code: string; // e.g. "FACTORY_ADMIN", "SUPPLIER_MEMBER", "SUPER_ADMIN"
  name: string;
  description: string;
  isSystemRole: boolean;
  permissionCodes: string[];
  createdAt: Date;
  updatedAt: Date;
}

export class Role {
  private props: RoleProps;

  private constructor(props: RoleProps) {
    this.props = props;
  }

  public static create(
    code: string,
    name: string,
    description: string,
    isSystemRole = false,
    permissionCodes: string[] = [],
  ): Role {
    const now = new Date();
    return new Role({
      id: RoleId.create(),
      code: code.toUpperCase(),
      name,
      description,
      isSystemRole,
      permissionCodes: [...permissionCodes],
      createdAt: now,
      updatedAt: now,
    });
  }

  public static reconstitute(props: RoleProps): Role {
    return new Role(props);
  }

  public get id(): RoleId {
    return this.props.id;
  }
  public get code(): string {
    return this.props.code;
  }
  public get name(): string {
    return this.props.name;
  }
  public get description(): string {
    return this.props.description;
  }
  public get isSystemRole(): boolean {
    return this.props.isSystemRole;
  }
  public get permissionCodes(): string[] {
    return [...this.props.permissionCodes];
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt;
  }

  public addPermission(permissionCode: string): void {
    const normalized = permissionCode.toLowerCase();
    if (!this.props.permissionCodes.includes(normalized)) {
      this.props.permissionCodes.push(normalized);
      this.props.updatedAt = new Date();
    }
  }

  public removePermission(permissionCode: string): void {
    const normalized = permissionCode.toLowerCase();
    this.props.permissionCodes = this.props.permissionCodes.filter((p) => p !== normalized);
    this.props.updatedAt = new Date();
  }

  public hasPermission(permissionCode: string): boolean {
    return this.props.permissionCodes.includes(permissionCode.toLowerCase());
  }
}
