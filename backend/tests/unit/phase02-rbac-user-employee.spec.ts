import { PermissionCheckerService } from '../../src/modules/auth/authorization/services/permission-checker.service.js';
import { PermissionResolverService } from '../../src/modules/auth/authorization/services/permission-resolver.service.js';
import { IRoleRepository } from '../../src/modules/auth/authorization/domain/repositories/role.repository.interface.js';
import { Role } from '../../src/modules/auth/authorization/domain/entities/role.entity.js';
import { RoleId } from '../../src/modules/auth/authorization/domain/value-objects/role-id.vo.js';
import { updateMeSchema } from '../../src/modules/users/application/dtos/user.dto.js';
import { createEmployeeSchema } from '../../src/modules/employees/application/dtos/employee.dto.js';
import { DEFAULT_ROLE_PERMISSIONS } from '../../src/config/permissions.config.js';

class MockRoleRepository implements IRoleRepository {
  private roles: Role[] = [];

  constructor() {
    this.roles = [
      Role.reconstitute({
        id: RoleId.create('11111111-1111-4111-a111-111111111111'),
        code: 'ADMIN',
        name: 'Admin',
        description: 'Admin',
        isSystemRole: true,
        permissionCodes: ['*'],
        createdAt: new Date(),
        updatedAt: new Date(),
      }),
      Role.reconstitute({
        id: RoleId.create('22222222-2222-4222-a222-222222222222'),
        code: 'FACTORY',
        name: 'Factory',
        description: 'Factory',
        isSystemRole: true,
        permissionCodes: DEFAULT_ROLE_PERMISSIONS.FACTORY,
        createdAt: new Date(),
        updatedAt: new Date(),
      }),
      Role.reconstitute({
        id: RoleId.create('33333333-3333-4333-a333-333333333333'),
        code: 'SUPPLIER',
        name: 'Supplier',
        description: 'Supplier',
        isSystemRole: true,
        permissionCodes: DEFAULT_ROLE_PERMISSIONS.SUPPLIER,
        createdAt: new Date(),
        updatedAt: new Date(),
      }),
      Role.reconstitute({
        id: RoleId.create('44444444-4444-4444-a444-444444444444'),
        code: 'EMPLOYEE',
        name: 'Employee',
        description: 'Employee',
        isSystemRole: true,
        permissionCodes: DEFAULT_ROLE_PERMISSIONS.EMPLOYEE,
        createdAt: new Date(),
        updatedAt: new Date(),
      }),
    ];
  }

  async findByCode(code: string): Promise<Role | null> {
    return this.roles.find((r) => r.code === code.toUpperCase()) || null;
  }
  async findByCodes(codes: string[]): Promise<Role[]> {
    const upper = codes.map((c) => c.toUpperCase());
    return this.roles.filter((r) => upper.includes(r.code));
  }
  async findAll(): Promise<Role[]> {
    return this.roles;
  }
  async save(): Promise<void> {}
}

describe('Phase 02 Unit Tests — RBAC, Permissions, User Profile & Employee Protection', () => {
  let permissionChecker: PermissionCheckerService;

  beforeEach(() => {
    const roleRepo = new MockRoleRepository();
    const resolver = new PermissionResolverService(roleRepo);
    permissionChecker = new PermissionCheckerService(resolver);
  });

  describe('RBAC & Permission Checker', () => {
    it('should grant all permissions to ADMIN (*)', async () => {
      const allowed = await permissionChecker.hasPermission(['ADMIN'], 'any.random.permission');
      expect(allowed).toBe(true);
    });

    it('should grant rfq.create to FACTORY role', async () => {
      const allowed = await permissionChecker.hasPermission(['FACTORY'], 'rfq.create');
      expect(allowed).toBe(true);
    });

    it('should deny admin.access to SUPPLIER role', async () => {
      const allowed = await permissionChecker.hasPermission(['SUPPLIER'], 'admin.access');
      expect(allowed).toBe(false);
    });

    it('should deny rfq.create to base EMPLOYEE role', async () => {
      const allowed = await permissionChecker.hasPermission(['EMPLOYEE'], 'rfq.create');
      expect(allowed).toBe(false);
    });
  });

  describe('User Profile DTO Protection (Mass Assignment Protection)', () => {
    it('should allow valid profile updates', () => {
      const validPayload = {
        companyName: 'New Factory Name',
        address: '123 Industrial St',
        city: 'Cairo',
      };
      const result = updateMeSchema.safeParse(validPayload);
      expect(result.success).toBe(true);
    });

    it('should reject strict validation when forbidden/unrecognized attributes are passed', () => {
      const forbiddenPayload = {
        companyName: 'Valid Name',
        role: 'admin', // Strict mode must reject role tampering
      };
      const result = updateMeSchema.safeParse(forbiddenPayload);
      expect(result.success).toBe(false);
    });
  });

  describe('Employee DTO Validation', () => {
    it('should validate valid employee creation payload', () => {
      const payload = {
        fullName: 'Sameh Accountant',
        email: 'sameh@factory.com',
        phone: '+201011223344',
        position: 'Accountant',
        role: 'employee',
        permissions: ['orders.read', 'payments.read'],
      };
      const result = createEmployeeSchema.safeParse(payload);
      expect(result.success).toBe(true);
    });
  });
});
