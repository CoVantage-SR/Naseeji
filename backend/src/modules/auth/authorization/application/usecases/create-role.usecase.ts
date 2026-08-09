import crypto from 'crypto';
import { MongoRoleRepository } from '../../data/repositories/mongo-role.repository.js';
import { SecurityLogRepository } from '../../../infrastructure/repositories/security-log.repository.js';
import { Role } from '../../domain/entities/role.entity.js';
import { CreateRoleDto, RoleResponseDto } from '../../presentation/dtos/role-permission.dto.js';
import { BusinessException } from '../../../../../core/errors/business.exception.js';

export class CreateRoleUseCase {
  constructor(
    private roleRepo: MongoRoleRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    dto: CreateRoleDto,
    actorUserId: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<RoleResponseDto> {
    const codeUpper = dto.code.toUpperCase().trim();
    const existing = await this.roleRepo.findByCode(codeUpper);
    if (existing) {
      throw new BusinessException(`Role with code "${codeUpper}" already exists.`);
    }

    const role = Role.create(
      codeUpper,
      dto.name,
      dto.description || '',
      false,
      (dto.permissionCodes || []).map((p) => p.toLowerCase()),
    );

    await this.roleRepo.save(role);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action: 'ROLE_CREATED',
      ipAddress,
      userAgent,
      metadata: { roleId: role.id.value, roleCode: role.code },
    });

    return {
      id: role.id.value,
      code: role.code,
      name: role.name,
      description: role.description,
      isSystemRole: role.isSystemRole,
      permissionCodes: role.permissionCodes,
      createdAt: role.createdAt.toISOString(),
      updatedAt: role.updatedAt.toISOString(),
    };
  }
}
