import { Request, Response, NextFunction } from 'express';
import { ListRolesUseCase } from '../../application/usecases/list-roles.usecase.js';
import { CreateRoleUseCase } from '../../application/usecases/create-role.usecase.js';
import { UpdateRoleUseCase } from '../../application/usecases/update-role.usecase.js';
import { DeleteRoleUseCase } from '../../application/usecases/delete-role.usecase.js';
import { ListPermissionsUseCase } from '../../application/usecases/list-permissions.usecase.js';
import { AuthenticationException } from '../../../../../core/errors/auth.exception.js';

export class RolePermissionController {
  constructor(
    private listRolesUseCase: ListRolesUseCase,
    private createRoleUseCase: CreateRoleUseCase,
    private updateRoleUseCase: UpdateRoleUseCase,
    private deleteRoleUseCase: DeleteRoleUseCase,
    private listPermissionsUseCase: ListPermissionsUseCase,
  ) {}

  private extractActorUserId(req: Request): string {
    const userId = req.userContext?.userId;
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return userId;
  }

  public listRoles = async (_req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await this.listRolesUseCase.execute();
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public createRole = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const result = await this.createRoleUseCase.execute(
        req.body,
        actorUserId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(201).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public updateRole = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const roleId = req.params.id || '';
      const result = await this.updateRoleUseCase.execute(
        roleId,
        req.body,
        actorUserId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public deleteRole = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const roleId = req.params.id || '';
      const result = await this.deleteRoleUseCase.execute(
        roleId,
        actorUserId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(err);
    }
  };

  public listPermissions = async (
    _req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const result = await this.listPermissionsUseCase.execute();
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };
}
