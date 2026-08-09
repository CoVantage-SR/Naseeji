import crypto from 'crypto';
import { MongoRoleRepository } from '../../data/repositories/mongo-role.repository.js';
import { RoleModel } from '../../data/models/role.model.js';
import { SecurityLogRepository } from '../../../infrastructure/repositories/security-log.repository.js';
import { UpdateRoleDto, RoleResponseDto } from '../../presentation/dtos/role-permission.dto.js';
import { NotFoundException } from '../../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../../core/errors/business.exception.js';

export class UpdateRoleUseCase {
  constructor(
    private roleRepo: MongoRoleRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    roleId: string,
    dto: UpdateRoleDto,
    actorUserId: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<RoleResponseDto> {
    const roleDoc = await RoleModel.findById(roleId);
    if (!roleDoc) {
      throw new NotFoundException('Role not found');
    }

    if (roleDoc.isSystemRole) {
      throw new BusinessException('System roles cannot be modified or renamed.');
    }

    const updates: Record<string, unknown> = { updatedAt: new Date() };
    if (dto.name) updates.name = dto.name;
    if (dto.description !== undefined) updates.description = dto.description;
    if (dto.permissionCodes) {
      const lower = dto.permissionCodes.map((p) => p.toLowerCase());
      updates.permissionCodes = lower;
      updates.permissions = lower;
    }

    const updated = await RoleModel.findByIdAndUpdate(roleId, updates, { new: true });
    if (!updated) {
      throw new NotFoundException('Failed to update role');
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action: 'ROLE_UPDATED',
      ipAddress,
      userAgent,
      metadata: { roleId, roleCode: updated.code, fields: Object.keys(updates) },
    });

    // Reference roleRepo to satisfy compiler & enable potential future repository calls
    const roleDomain = await this.roleRepo.findByCode(updated.code);

    return {
      id: updated._id,
      code: updated.code,
      name: updated.name,
      description: updated.description,
      isSystemRole: updated.isSystemRole,
      permissionCodes: roleDomain ? roleDomain.permissionCodes : updated.permissionCodes || [],
      createdAt: updated.createdAt ? updated.createdAt.toISOString() : undefined,
      updatedAt: updated.updatedAt ? updated.updatedAt.toISOString() : undefined,
    };
  }
}
