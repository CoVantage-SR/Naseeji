import crypto from 'crypto';
import { EmployeeRepository } from '../../infrastructure/repositories/employee.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../../auth/infrastructure/repositories/session.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { EmployeeStatusType } from '../../infrastructure/database/employee.schema.js';
import { EmployeeResponseDto } from '../dtos/employee.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { AuthorizationException } from '../../../../core/errors/forbidden.exception.js';

export class ChangeEmployeeStatusUseCase {
  constructor(
    private employeeRepo: EmployeeRepository,
    private userRepo: UserRepository,
    private sessionRepo: SessionRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    actorUserId: string,
    employeeId: string,
    newStatus: EmployeeStatusType,
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

    const updated = await this.employeeRepo.update(employeeId, { status: newStatus });
    if (!updated) {
      throw new NotFoundException('Employee status update failed');
    }

    // Sync status to User record
    const userStatusMap: Record<EmployeeStatusType, 'active' | 'suspended' | 'deactivated'> = {
      active: 'active',
      suspended: 'suspended',
      deactivated: 'deactivated',
    };
    await this.userRepo.update(employee.userId, { status: userStatusMap[newStatus] });

    // Revoke sessions if suspended or deactivated
    if (newStatus !== 'active') {
      await this.sessionRepo.revokeAllUserSessions(employee.userId);
    }

    const action = newStatus === 'suspended' ? 'EMPLOYEE_SUSPENDED' : 'EMPLOYEE_STATUS_CHANGED';
    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action,
      ipAddress,
      userAgent,
      metadata: { employeeId, targetUserId: employee.userId, newStatus },
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
