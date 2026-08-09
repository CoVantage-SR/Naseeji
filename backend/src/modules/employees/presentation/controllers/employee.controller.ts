import { Request, Response, NextFunction } from 'express';
import { CreateEmployeeUseCase } from '../../application/usecases/create-employee.usecase.js';
import { ListEmployeesUseCase } from '../../application/usecases/list-employees.usecase.js';
import { GetEmployeeUseCase } from '../../application/usecases/get-employee.usecase.js';
import { UpdateEmployeeUseCase } from '../../application/usecases/update-employee.usecase.js';
import { ChangeEmployeeStatusUseCase } from '../../application/usecases/change-employee-status.usecase.js';
import { DeleteEmployeeUseCase } from '../../application/usecases/delete-employee.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

export class EmployeeController {
  constructor(
    private createEmployeeUseCase: CreateEmployeeUseCase,
    private listEmployeesUseCase: ListEmployeesUseCase,
    private getEmployeeUseCase: GetEmployeeUseCase,
    private updateEmployeeUseCase: UpdateEmployeeUseCase,
    private changeEmployeeStatusUseCase: ChangeEmployeeStatusUseCase,
    private deleteEmployeeUseCase: DeleteEmployeeUseCase,
  ) {}

  private extractActorUserId(req: Request): string {
    const userId = req.userContext?.userId;
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return userId;
  }

  public createEmployee = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const result = await this.createEmployeeUseCase.execute(
        actorUserId,
        req.body,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(201).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public listEmployees = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const result = await this.listEmployeesUseCase.execute(actorUserId);
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public getEmployee = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const employeeId = req.params.id || '';
      const result = await this.getEmployeeUseCase.execute(actorUserId, employeeId);
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public updateEmployee = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const employeeId = req.params.id || '';
      const result = await this.updateEmployeeUseCase.execute(
        actorUserId,
        employeeId,
        req.body,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public changeEmployeeStatus = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const employeeId = req.params.id || '';
      const result = await this.changeEmployeeStatusUseCase.execute(
        actorUserId,
        employeeId,
        req.body.status,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public deleteEmployee = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const employeeId = req.params.id || '';
      const result = await this.deleteEmployeeUseCase.execute(
        actorUserId,
        employeeId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(err);
    }
  };
}
