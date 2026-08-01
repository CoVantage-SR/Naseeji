import { IPermissionDocument } from '../models/permission.model.js';
import { Permission } from '../../domain/entities/permission.entity.js';
import { PermissionId } from '../../domain/value-objects/permission-id.vo.js';

export class PermissionMapper {
  public static toDomain(doc: IPermissionDocument): Permission {
    return Permission.reconstitute({
      id: PermissionId.create(doc._id),
      code: doc.code,
      group: doc.group,
      description: doc.description,
      createdAt: doc.createdAt,
    });
  }

  public static toPersistence(permission: Permission): Record<string, unknown> {
    return {
      _id: permission.id.value,
      code: permission.code,
      group: permission.group,
      description: permission.description,
    };
  }
}
