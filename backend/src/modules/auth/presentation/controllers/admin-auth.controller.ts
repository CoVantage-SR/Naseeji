import { Request, Response, NextFunction } from 'express';
import { AdminLoginUseCase } from '../application/use-cases/admin-login.use-case.js';
import { ForceLogoutUserUseCase } from '../application/use-cases/force-logout-user.use-case.js';
import { BlockUserUseCase } from '../application/use-cases/block-user.use-case.js';
import { SuspendUserUseCase } from '../application/use-cases/suspend-user.use-case.js';
import { ActivateUserUseCase } from '../application/use-cases/activate-user.use-case.js';
import { AdminResetPasswordUseCase } from '../application/use-cases/admin-reset-password.use-case.js';
import { GetAuditLogsUseCase } from '../application/use-cases/get-audit-logs.use-case.js';
import { HttpStatus } from '@core/constants/http-status.constant.js';

export class AdminAuthController {
  constructor(
    private adminLoginUseCase: AdminLoginUseCase,
    private forceLogoutUserUseCase: ForceLogoutUserUseCase,
    private blockUserUseCase: BlockUserUseCase,
    private suspendUserUseCase: SuspendUserUseCase,
    private activateUserUseCase: ActivateUserUseCase,
    private adminResetPasswordUseCase: AdminResetPasswordUseCase,
    private getAuditLogsUseCase: GetAuditLogsUseCase,
  ) {}

  public login = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      const result = await this.adminLoginUseCase.execute({
        phone: req.body.phone,
        password: req.body.password,
        ipAddress,
        userAgent,
      });

      res.success(
        {
          user: {
            id: result.user.id,
            phone: result.user.phone.value,
            email: result.user.email,
            accountType: result.user.accountType,
            roles: result.user.roles,
          },
          tokens: result.tokens,
        },
        'Admin login successful',
        HttpStatus.OK,
      );
    } catch (error) {
      next(error);
    }
  };

  public forceLogout = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      await this.forceLogoutUserUseCase.execute({
        adminUserId: req.userContext!.userId,
        targetUserId: req.body.targetUserId,
        targetSessionId: req.body.targetSessionId,
        ipAddress,
        userAgent,
      });
      res.success(null, 'User session(s) force revoked successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };

  public blockUser = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      await this.blockUserUseCase.execute({
        adminUserId: req.userContext!.userId,
        targetUserId: req.params.id as string,
        reason: req.body.reason || 'Blocked by administrator',
        ipAddress,
        userAgent,
      });
      res.success(null, 'User blocked successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };

  public suspendUser = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      await this.suspendUserUseCase.execute({
        adminUserId: req.userContext!.userId,
        targetUserId: req.params.id as string,
        reason: req.body.reason || 'Suspended by administrator',
        ipAddress,
        userAgent,
      });
      res.success(null, 'User suspended successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };

  public activateUser = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      await this.activateUserUseCase.execute({
        adminUserId: req.userContext!.userId,
        targetUserId: req.params.id as string,
        ipAddress,
        userAgent,
      });
      res.success(null, 'User account activated successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };

  public resetUserPassword = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      await this.adminResetPasswordUseCase.execute({
        adminUserId: req.userContext!.userId,
        targetUserId: req.params.id as string,
        newPassword: req.body.newPassword,
        ipAddress,
        userAgent,
      });
      res.success(null, 'User password reset by admin successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };

  public getAuditLogs = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const logs = await this.getAuditLogsUseCase.execute({
        userId: req.query.userId as string | undefined,
        limit: req.query.limit ? Number(req.query.limit) : 50,
        offset: req.query.offset ? Number(req.query.offset) : 0,
      });
      res.success(logs, 'Audit logs retrieved successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };
}
