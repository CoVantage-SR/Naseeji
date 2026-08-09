import { IRoleDocument } from '../models/role.model.js';
import { Role } from '../../domain/entities/role.entity.js';
import { RoleId } from '../../domain/value-objects/role-id.vo.js';

export class RoleMapper {
  public static toDomain(doc: IRoleDocument): Role {
    const now = new Date();
    return Role.reconstitute({
      id: RoleId.create(doc._id),
      code: doc.code,
      name: doc.name,
      description: doc.description,
      isSystemRole: doc.isSystemRole,
      permissionCodes: doc.permissionCodes || doc.permissions || [],
      createdAt: doc.createdAt || now,
      updatedAt: doc.updatedAt || now,
    });
  }

  public static toPersistence(role: Role): Record<string, unknown> {
    return {
      _id: role.id.value,
      code: role.code,
      name: role.name,
      description: role.description,
      isSystemRole: role.isSystemRole,
      permissionCodes: role.permissionCodes,
      permissions: role.permissionCodes,
    };
  }
}
