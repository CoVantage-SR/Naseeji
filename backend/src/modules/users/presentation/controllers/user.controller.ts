import { Request, Response, NextFunction } from 'express';
import { GetMeUseCase } from '../../application/usecases/get-me.usecase.js';
import { UpdateMeUseCase } from '../../application/usecases/update-me.usecase.js';
import { AdminUserManagementUseCase } from '../../application/usecases/admin-user-management.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

import { UserRoleType, UserStatusType } from '../../../auth/infrastructure/database/user.schema.js';

export class UserController {
  constructor(
    private getMeUseCase: GetMeUseCase,
    private updateMeUseCase: UpdateMeUseCase,
    private adminUserManagementUseCase: AdminUserManagementUseCase,
  ) {}

  private extractActorUserId(req: Request): string {
    const userId = req.userContext?.userId;
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return userId;
  }

  public getMe = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractActorUserId(req);
      const data = await this.getMeUseCase.execute(userId);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public updateMe = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractActorUserId(req);
      const data = await this.updateMeUseCase.execute(
        userId,
        req.body,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public listUsers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = {
        search: req.query.search as string | undefined,
        role: req.query.role as UserRoleType | undefined,
        status: req.query.status as UserStatusType | undefined,
        page: req.query.page ? parseInt(req.query.page as string, 10) : 1,
        limit: req.query.limit ? parseInt(req.query.limit as string, 10) : 20,
      };
      const result = await this.adminUserManagementUseCase.listUsers(query);
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public getUserById = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const targetUserId = req.params.id || '';
      const data = await this.adminUserManagementUseCase.getUserById(targetUserId);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public updateUserStatus = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const actorUserId = this.extractActorUserId(req);
      const targetUserId = req.params.id || '';
      const { status, reason } = req.body;
      const result = await this.adminUserManagementUseCase.updateUserStatus(
        targetUserId,
        status,
        actorUserId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
        reason,
      );
      res.status(200).json(result);
    } catch (err) {
      next(err);
    }
  };
}
