import { MongoPermissionRepository } from '../../data/repositories/mongo-permission.repository.js';
import { PERMISSIONS_CATALOG } from '../../../../../config/permissions.config.js';
import { PermissionResponseDto } from '../../presentation/dtos/role-permission.dto.js';

export class ListPermissionsUseCase {
  constructor(private permissionRepo: MongoPermissionRepository) {}

  public async execute(): Promise<PermissionResponseDto[]> {
    const dbPermissions = await this.permissionRepo.findAll();

    if (dbPermissions.length > 0) {
      return dbPermissions.map((p) => ({
        id: p.id.value,
        code: p.code,
        group: p.group,
        description: p.description,
      }));
    }

    return PERMISSIONS_CATALOG.map((p, index) => ({
      id: `perm-${index + 1}`,
      code: p.code,
      group: p.group,
      description: p.description,
    }));
  }
}
