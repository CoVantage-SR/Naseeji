import crypto from 'crypto';
import { EmployeeRepository } from '../../infrastructure/repositories/employee.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../../auth/infrastructure/repositories/session.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { AuthorizationException } from '../../../../core/errors/forbidden.exception.js';

export class DeleteEmployeeUseCase {
  constructor(
    private employeeRepo: EmployeeRepository,
    private userRepo: UserRepository,
    private sessionRepo: SessionRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    actorUserId: string,
    employeeId: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<{ success: boolean; message: string }> {
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
        'Organization Boundary Violation: You cannot delete employees belonging to another organization.',
      );
    }

    await this.sessionRepo.revokeAllUserSessions(employee.userId);
    await this.userRepo.update(employee.userId, { status: 'deleted', deletedAt: new Date() });
    await this.employeeRepo.update(employeeId, { status: 'deactivated' });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action: 'EMPLOYEE_DELETED',
      ipAddress,
      userAgent,
      metadata: { employeeId, targetUserId: employee.userId },
    });

    return { success: true, message: 'Employee access revoked and account deleted.' };
  }
}
