import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { EmployeeRepository } from '../../infrastructure/repositories/employee.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { CreateEmployeeDto, EmployeeResponseDto } from '../dtos/employee.dto.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

/** Permissions that employees must never be granted to prevent privilege escalation */
const DISALLOWED_EMPLOYEE_PERMISSIONS = [
  '*',
  'admin.access',
  'roles.create',
  'roles.update',
  'roles.delete',
];

export class CreateEmployeeUseCase {
  constructor(
    private employeeRepo: EmployeeRepository,
    private userRepo: UserRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    actorUserId: string,
    dto: CreateEmployeeDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<EmployeeResponseDto> {
    const actorUser = await this.userRepo.findById(actorUserId);
    if (!actorUser) {
      throw new NotFoundException('Actor account not found');
    }

    let organizationId = '';
    let organizationType: 'factory' | 'supplier' = 'factory';

    if (actorUser.factoryId) {
      organizationId = actorUser.factoryId;
      organizationType = 'factory';
    } else if (actorUser.supplierId) {
      organizationId = actorUser.supplierId;
      organizationType = 'supplier';
    } else if (actorUser.role === 'admin') {
      organizationId = 'admin-org';
      organizationType = 'factory';
    } else {
      throw new BusinessException(
        'You must belong to a factory or supplier organization to create employees.',
      );
    }

    const normalizedEmail = dto.email.toLowerCase().trim();
    const normalizedPhone = dto.phone.replace(/\s+/g, '').replace(/[^\d+]/g, '');

    const existingEmail = await this.userRepo.findByEmail(normalizedEmail);
    if (existingEmail) {
      throw new BusinessException('Employee email is already registered in the system.');
    }

    const existingPhone = await this.userRepo.findByPhone(normalizedPhone);
    if (existingPhone) {
      throw new BusinessException('Employee phone number is already registered in the system.');
    }

    // Filter out disallowed administrative permissions (privilege escalation check)
    const safePermissions = (dto.permissions || []).filter(
      (p) => !DISALLOWED_EMPLOYEE_PERMISSIONS.includes(p.toLowerCase()),
    );

    const rawPassword = dto.password || `Emp@${Math.floor(100000 + Math.random() * 900000)}`;
    const rounds = parseInt(process.env.PASSWORD_HASH_ROUNDS || '12', 10);
    const passwordHash = await bcrypt.hash(rawPassword, rounds);

    const userId = crypto.randomUUID();
    const employeeId = crypto.randomUUID();

    // Create User record
    await this.userRepo.create({
      _id: userId,
      phone: normalizedPhone,
      email: normalizedEmail,
      passwordHash,
      role: 'employee',
      status: 'active',
      isEmailVerified: true,
      isPhoneVerified: true,
      ...(organizationType === 'factory'
        ? { factoryId: organizationId }
        : { supplierId: organizationId }),
      employeeId,
    });

    // Create Employee record
    const employee = await this.employeeRepo.create({
      _id: employeeId,
      userId,
      organizationId,
      organizationType,
      fullName: dto.fullName,
      email: normalizedEmail,
      phone: normalizedPhone,
      position: dto.position || 'Employee',
      role: dto.role || 'employee',
      permissions: safePermissions,
      status: 'active',
    });

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action: 'EMPLOYEE_CREATED',
      ipAddress,
      userAgent,
      metadata: { employeeId, userId, organizationId, role: employee.role },
    });

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
