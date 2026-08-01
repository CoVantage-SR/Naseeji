import { Permission } from '../entities/permission.entity.js';

export interface IPermissionRepository {
  save(permission: Permission): Promise<void>;
  findByCode(code: string): Promise<Permission | null>;
  findByCodes(codes: string[]): Promise<Permission[]>;
  findAll(): Promise<Permission[]>;
}
