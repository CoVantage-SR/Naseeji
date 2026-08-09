import crypto from 'crypto';
import { RoleModel } from '../../data/models/role.model.js';
import { SecurityLogRepository } from '../../../infrastructure/repositories/security-log.repository.js';
import { NotFoundException } from '../../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../../core/errors/business.exception.js';

export class DeleteRoleUseCase {
  constructor(private securityLogRepo: SecurityLogRepository) {}

  public async execute(
    roleId: string,
    actorUserId: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<{ success: boolean; message: string }> {
    const role = await RoleModel.findById(roleId);
    if (!role) {
      throw new NotFoundException('Role not found');
    }

    if (role.isSystemRole) {
      throw new BusinessException('System roles cannot be deleted.');
    }

    await RoleModel.deleteOne({ _id: roleId });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action: 'ROLE_DELETED',
      ipAddress,
      userAgent,
      metadata: { roleId, roleCode: role.code },
    });

    return { success: true, message: `Role "${role.name}" (${role.code}) deleted successfully.` };
  }
}
