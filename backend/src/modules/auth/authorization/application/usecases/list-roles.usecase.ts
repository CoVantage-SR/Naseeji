import { MongoRoleRepository } from '../../data/repositories/mongo-role.repository.js';
import { RoleResponseDto } from '../../presentation/dtos/role-permission.dto.js';

export class ListRolesUseCase {
  constructor(private roleRepo: MongoRoleRepository) {}

  public async execute(): Promise<RoleResponseDto[]> {
    const roles = await this.roleRepo.findAll();
    return roles.map((r) => ({
      id: r.id.value,
      code: r.code,
      name: r.name,
      description: r.description,
      isSystemRole: r.isSystemRole,
      permissionCodes: r.permissionCodes,
      createdAt: r.createdAt ? r.createdAt.toISOString() : undefined,
      updatedAt: r.updatedAt ? r.updatedAt.toISOString() : undefined,
    }));
  }
}
