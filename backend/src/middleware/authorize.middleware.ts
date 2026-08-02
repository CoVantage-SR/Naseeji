import { Request, Response, NextFunction } from 'express';
import { PermissionCheckerService } from '../modules/auth/authorization/services/permission-checker.service.js';
import { PermissionResolverService } from '../modules/auth/authorization/services/permission-resolver.service.js';
import { MongoRoleRepository } from '../modules/auth/authorization/data/repositories/mongo-role.repository.js';
import { AuthorizationException } from '../core/errors/forbidden.exception.js';
import { AuthenticationException } from '../core/errors/auth.exception.js';

export const authorize = (requiredPermission: string) => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    if (!req.userContext) {
      return next(new AuthenticationException('User context missing. Must authenticate first.'));
    }

    try {
      const roleRepo = new MongoRoleRepository();
      const resolver = new PermissionResolverService(roleRepo);
      const checker = new PermissionCheckerService(resolver);

      await checker.ensurePermission(req.userContext.roles, requiredPermission);
      next();
    } catch (error) {
      if (error instanceof AuthorizationException) {
        next(error);
      } else {
        next(new AuthorizationException('Permission denied for requested endpoint'));
      }
    }
  };
};
