import { Request, Response, NextFunction } from 'express';

interface RequestWithUserRole extends Request {
  user?: {
    role?: string;
    roles?: string[];
  };
}

export const requireRoles = (...allowedRoles: string[]) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    const customReq = req as RequestWithUserRole;
    const user = req.userContext || customReq.user;
    if (!user) {
      res.status(401).json({
        success: false,
        message: 'Unauthorized access',
      });
      return;
    }

    const userRole = user.role || (user.roles && user.roles[0]);
    if (!userRole || !allowedRoles.includes(userRole)) {
      res.status(403).json({
        success: false,
        message: `Forbidden: Access restricted to roles [${allowedRoles.join(', ')}]`,
      });
      return;
    }

    next();
  };
};
