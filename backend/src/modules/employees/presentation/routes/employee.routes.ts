import { Router } from 'express';
import { authenticateMiddleware } from '@middleware/authenticate.middleware.js';
import { requireRoles } from '@middleware/rbac.middleware.js';
import { validateRequest } from '@middleware/request-validator.middleware.js';
import {
  createEmployeeSchema,
  updateEmployeeSchema,
  changeEmployeeStatusSchema,
} from '../../application/dtos/employee.dto.js';

// Repositories
import { EmployeeRepository } from '../../infrastructure/repositories/employee.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../../auth/infrastructure/repositories/session.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';

// Use Cases
import { CreateEmployeeUseCase } from '../../application/usecases/create-employee.usecase.js';
import { ListEmployeesUseCase } from '../../application/usecases/list-employees.usecase.js';
import { GetEmployeeUseCase } from '../../application/usecases/get-employee.usecase.js';
import { UpdateEmployeeUseCase } from '../../application/usecases/update-employee.usecase.js';
import { ChangeEmployeeStatusUseCase } from '../../application/usecases/change-employee-status.usecase.js';
import { DeleteEmployeeUseCase } from '../../application/usecases/delete-employee.usecase.js';

// Controller
import { EmployeeController } from '../controllers/employee.controller.js';

const employeeRepo = new EmployeeRepository();
const userRepo = new UserRepository();
const sessionRepo = new SessionRepository();
const securityLogRepo = new SecurityLogRepository();

const createEmployeeUseCase = new CreateEmployeeUseCase(employeeRepo, userRepo, securityLogRepo);
const listEmployeesUseCase = new ListEmployeesUseCase(employeeRepo, userRepo);
const getEmployeeUseCase = new GetEmployeeUseCase(employeeRepo, userRepo);
const updateEmployeeUseCase = new UpdateEmployeeUseCase(employeeRepo, userRepo, securityLogRepo);
const changeEmployeeStatusUseCase = new ChangeEmployeeStatusUseCase(
  employeeRepo,
  userRepo,
  sessionRepo,
  securityLogRepo,
);
const deleteEmployeeUseCase = new DeleteEmployeeUseCase(
  employeeRepo,
  userRepo,
  sessionRepo,
  securityLogRepo,
);

const controller = new EmployeeController(
  createEmployeeUseCase,
  listEmployeesUseCase,
  getEmployeeUseCase,
  updateEmployeeUseCase,
  changeEmployeeStatusUseCase,
  deleteEmployeeUseCase,
);

const router = Router();

router.use(authenticateMiddleware);

// Organization owners (factory, supplier) & admins can manage employees
router.get('/', requireRoles('factory', 'supplier', 'admin'), controller.listEmployees);
router.post(
  '/',
  requireRoles('factory', 'supplier', 'admin'),
  validateRequest(createEmployeeSchema),
  controller.createEmployee,
);
router.get('/:id', requireRoles('factory', 'supplier', 'admin'), controller.getEmployee);
router.patch(
  '/:id',
  requireRoles('factory', 'supplier', 'admin'),
  validateRequest(updateEmployeeSchema),
  controller.updateEmployee,
);
router.patch(
  '/:id/status',
  requireRoles('factory', 'supplier', 'admin'),
  validateRequest(changeEmployeeStatusSchema),
  controller.changeEmployeeStatus,
);
router.delete('/:id', requireRoles('factory', 'supplier', 'admin'), controller.deleteEmployee);

export const employeeRouter = router;
