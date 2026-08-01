import { PermissionResolverService } from './permission-resolver.service.js';
import { PermissionDeniedException } from '../../domain/errors/auth-domain.exceptions.js';

export class PermissionCheckerService {
  constructor(private permissionResolver: PermissionResolverService) {}

  public async hasPermission(roleCodes: string[], requiredPermission: string): Promise<boolean> {
    const grantedPermissions = await this.permissionResolver.resolvePermissionsForRoles(roleCodes);
    const target = requiredPermission.toLowerCase();
    return grantedPermissions.includes(target) || grantedPermissions.includes('*');
  }

  public async ensurePermission(roleCodes: string[], requiredPermission: string): Promise<void> {
    const allowed = await this.hasPermission(roleCodes, requiredPermission);
    if (!allowed) {
      throw new PermissionDeniedException(
        `Access denied: Missing required permission "${requiredPermission}"`,
      );
    }
  }
}
