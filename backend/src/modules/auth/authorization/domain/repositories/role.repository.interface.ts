import { Role } from '../entities/role.entity.js';

export interface IRoleRepository {
  save(role: Role): Promise<void>;
  findByCode(code: string): Promise<Role | null>;
  findByCodes(codes: string[]): Promise<Role[]>;
  findAll(): Promise<Role[]>;
}
