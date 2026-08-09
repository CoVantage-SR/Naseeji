import { EmployeeRepository } from '../../infrastructure/repositories/employee.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { EmployeeResponseDto } from '../dtos/employee.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { AuthorizationException } from '../../../../core/errors/forbidden.exception.js';

export class GetEmployeeUseCase {
  constructor(
    private employeeRepo: EmployeeRepository,
    private userRepo: UserRepository,
  ) {}

  public async execute(actorUserId: string, employeeId: string): Promise<EmployeeResponseDto> {
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
        'Organization Boundary Violation: You cannot access employees belonging to another organization.',
      );
    }

    return {
      id: employee._id,
      userId: employee.userId,
      organizationId: employee.organizationId,
      organizationType: employee.organizationType,
      fullName: employee.fullName,
      email: employee.email,
      phone: employee.phone,
      position: employee.position,
      role: employee.role,
      permissions: employee.permissions,
      status: employee.status,
      createdAt: employee.createdAt ? employee.createdAt.toISOString() : undefined,
      updatedAt: employee.updatedAt ? employee.updatedAt.toISOString() : undefined,
    };
  }
}
