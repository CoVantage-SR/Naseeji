import { EmployeeRepository } from '../../infrastructure/repositories/employee.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { EmployeeResponseDto } from '../dtos/employee.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';

export class ListEmployeesUseCase {
  constructor(
    private employeeRepo: EmployeeRepository,
    private userRepo: UserRepository,
  ) {}

  public async execute(actorUserId: string): Promise<EmployeeResponseDto[]> {
    const actorUser = await this.userRepo.findById(actorUserId);
    if (!actorUser) {
      throw new NotFoundException('Actor account not found');
    }

    const organizationId = actorUser.factoryId || actorUser.supplierId;
    if (!organizationId && actorUser.role !== 'admin') {
      throw new BusinessException('You do not belong to an organization.');
    }

    const employees = organizationId
      ? await this.employeeRepo.findByOrganizationId(organizationId)
      : [];

    return employees.map((emp) => ({
      id: emp._id,
      userId: emp.userId,
      organizationId: emp.organizationId,
      organizationType: emp.organizationType,
      fullName: emp.fullName,
      email: emp.email,
      phone: emp.phone,
      position: emp.position,
      role: emp.role,
      permissions: emp.permissions,
      status: emp.status,
      createdAt: emp.createdAt ? emp.createdAt.toISOString() : undefined,
      updatedAt: emp.updatedAt ? emp.updatedAt.toISOString() : undefined,
    }));
  }
}
