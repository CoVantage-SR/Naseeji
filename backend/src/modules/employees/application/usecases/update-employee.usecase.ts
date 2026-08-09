import crypto from 'crypto';
import { EmployeeRepository } from '../../infrastructure/repositories/employee.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { UpdateEmployeeDto, EmployeeResponseDto } from '../dtos/employee.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { AuthorizationException } from '../../../../core/errors/forbidden.exception.js';

const DISALLOWED_EMPLOYEE_PERMISSIONS = [
  '*',
  'admin.access',
  'roles.create',
  'roles.update',
  'roles.delete',
];

export class UpdateEmployeeUseCase {
  constructor(
    private employeeRepo: EmployeeRepository,
    private userRepo: UserRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    actorUserId: string,
    employeeId: string,
    dto: UpdateEmployeeDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<EmployeeResponseDto> {
    const actorUser = await this.userRepo.findById(actorUserId);
    if (!actorUser) {
      throw new NotFoundException('Actor account not found');
    }

    const employee = await this.employeeRepo.findById(employeeId);
    if (!employee) {
      throw new NotFoundException('Employee not found');
    }

    const organizationId = actorUser.factoryId || actorUser.supplierId;
    if (actorUser.role !== 'admin' && employee.organizationId !== organizationId) {
      throw new AuthorizationException(
        'Organization Boundary Violation: You cannot modify employees belonging to another organization.',
      );
    }

    const updates: Record<string, unknown> = {};
    if (dto.fullName) updates.fullName = dto.fullName;
    if (dto.position) updates.position = dto.position;
    if (dto.role) updates.role = dto.role;

    if (dto.permissions) {
      updates.permissions = dto.permissions.filter(
        (p) => !DISALLOWED_EMPLOYEE_PERMISSIONS.includes(p.toLowerCase()),
      );
    }

    const updated = await this.employeeRepo.update(employeeId, updates);
    if (!updated) {
      throw new NotFoundException('Failed to update employee record');
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action: 'EMPLOYEE_UPDATED',
      ipAddress,
      userAgent,
      metadata: { employeeId, fields: Object.keys(updates) },
    });

    return {
      id: updated._id,
      userId: updated.userId,
      organizationId: updated.organizationId,
      organizationType: updated.organizationType,
      fullName: updated.fullName,
      email: updated.email,
      phone: updated.phone,
      position: updated.position,
      role: updated.role,
      permissions: updated.permissions,
      status: updated.status,
      createdAt: updated.createdAt ? updated.createdAt.toISOString() : undefined,
      updatedAt: updated.updatedAt ? updated.updatedAt.toISOString() : undefined,
    };
  }
}
