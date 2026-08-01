import { IRoleRepository } from '../domain/repositories/role.repository.interface.js';

export class PermissionResolverService {
  constructor(private roleRepo: IRoleRepository) {}

  public async resolvePermissionsForRoles(roleCodes: string[]): Promise<string[]> {
    if (!roleCodes || roleCodes.length === 0) return [];
    const roles = await this.roleRepo.findByCodes(roleCodes);
    const permissionSet = new Set<string>();

    for (const role of roles) {
      for (const permCode of role.permissionCodes) {
        permissionSet.add(permCode.toLowerCase());
      }
    }

    return Array.from(permissionSet);
  }
}
