import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { requireRoles } from '@middleware/rbac.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import { createRoleSchema, updateRoleSchema } from '../dtos/role-permission.dto.js';

// Repositories
import { MongoRoleRepository } from '../../data/repositories/mongo-role.repository.js';
import { MongoPermissionRepository } from '../../data/repositories/mongo-permission.repository.js';
import { SecurityLogRepository } from '../../../infrastructure/repositories/security-log.repository.js';

// Use Cases
import { ListRolesUseCase } from '../../application/usecases/list-roles.usecase.js';
import { CreateRoleUseCase } from '../../application/usecases/create-role.usecase.js';
import { UpdateRoleUseCase } from '../../application/usecases/update-role.usecase.js';
import { DeleteRoleUseCase } from '../../application/usecases/delete-role.usecase.js';
import { ListPermissionsUseCase } from '../../application/usecases/list-permissions.usecase.js';

// Controller
import { RolePermissionController } from '../controllers/role-permission.controller.js';

const roleRepo = new MongoRoleRepository();
const permissionRepo = new MongoPermissionRepository();
const securityLogRepo = new SecurityLogRepository();

const listRolesUseCase = new ListRolesUseCase(roleRepo);
const createRoleUseCase = new CreateRoleUseCase(roleRepo, securityLogRepo);
const updateRoleUseCase = new UpdateRoleUseCase(roleRepo, securityLogRepo);
const deleteRoleUseCase = new DeleteRoleUseCase(securityLogRepo);
const listPermissionsUseCase = new ListPermissionsUseCase(permissionRepo);

const controller = new RolePermissionController(
  listRolesUseCase,
  createRoleUseCase,
  updateRoleUseCase,
  deleteRoleUseCase,
  listPermissionsUseCase,
);

const roleRouter = Router();
const permissionRouter = Router();

roleRouter.use(authenticateMiddleware);
permissionRouter.use(authenticateMiddleware);

// Roles management
roleRouter.get('/', requireRoles('admin', 'support', 'auditor'), controller.listRoles);
roleRouter.post(
  '/',
  requireRoles('admin'),
  validateRequest(createRoleSchema),
  controller.createRole,
);
roleRouter.patch(
  '/:id',
  requireRoles('admin'),
  validateRequest(updateRoleSchema),
  controller.updateRole,
);
roleRouter.delete('/:id', requireRoles('admin'), controller.deleteRole);

// Permissions listing
permissionRouter.get('/', requireRoles('admin', 'support', 'auditor'), controller.listPermissions);

export const roleApiRouter = roleRouter;
export const permissionApiRouter = permissionRouter;
