import { Request, Response, NextFunction } from 'express';
import { AuthenticationException } from '../core/errors/auth.exception.js';
import { AuthorizationException } from '../core/errors/forbidden.exception.js';

export const requireRoles = (...allowedRoles: string[]) => {
  const normalizedAllowed = allowedRoles.map((r) => r.toLowerCase().trim());

  return (req: Request, _res: Response, next: NextFunction): void => {
    const user = req.userContext;
    if (!user || !user.userId) {
      return next(new AuthenticationException('User context missing. Must authenticate first.'));
    }

    const userRoles = [
      ...(user.role ? [user.role.toLowerCase()] : []),
      ...(user.roles ? user.roles.map((r) => r.toLowerCase()) : []),
    ];

    const hasRole = userRoles.some((role) => normalizedAllowed.includes(role));

    if (!hasRole) {
      return next(
        new AuthorizationException(
          `Forbidden: Required role matching [${allowedRoles.join(', ')}]`,
        ),
      );
    }

    next();
  };
};

export const requireRole = requireRoles;
