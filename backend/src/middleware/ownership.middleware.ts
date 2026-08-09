import { Request, Response, NextFunction } from 'express';
import { AuthenticationException } from '../core/errors/auth.exception.js';
import { AuthorizationException } from '../core/errors/forbidden.exception.js';
import { UserModel } from '../modules/auth/infrastructure/database/user.schema.js';

export const assertResourceOwnership = (paramName = 'userId') => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    if (!req.userContext || !req.userContext.userId) {
      return next(new AuthenticationException('User context missing. Must authenticate first.'));
    }

    const currentUserId = req.userContext.userId;
    const currentUserRole = req.userContext.role || req.userContext.accountType;

    // Admin users bypass resource ownership checks
    if (currentUserRole === 'admin' || currentUserRole === 'ADMIN') {
      return next();
    }

    const targetId = req.params[paramName] || req.body[paramName] || req.query[paramName];
    if (!targetId) {
      return next();
    }

    if (targetId !== currentUserId) {
      return next(
        new AuthorizationException(
          'Resource Ownership Violation: You are not authorized to access or modify resources belonging to another user.',
        ),
      );
    }

    next();
  };
};

export const assertFactoryOwnership = (factoryIdParam = 'factoryId') => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    if (!req.userContext || !req.userContext.userId) {
      return next(new AuthenticationException('User context missing. Must authenticate first.'));
    }

    const currentUserRole = req.userContext.role || req.userContext.accountType;
    if (currentUserRole === 'admin' || currentUserRole === 'ADMIN') {
      return next();
    }

    const targetFactoryId =
      req.params[factoryIdParam] || req.body[factoryIdParam] || req.query[factoryIdParam];
    if (!targetFactoryId) {
      return next();
    }

    const user = await UserModel.findById(req.userContext.userId).lean();
    if (!user || (!user.factoryId && user.role !== 'admin')) {
      return next(
        new AuthorizationException('Forbidden: User does not belong to a factory organization.'),
      );
    }

    if (user.factoryId !== targetFactoryId) {
      return next(
        new AuthorizationException(
          'Organization Boundary Violation: You cannot access or modify resources belonging to another factory.',
        ),
      );
    }

    next();
  };
};

export const assertSupplierOwnership = (supplierIdParam = 'supplierId') => {
  return async (req: Request, _res: Response, next: NextFunction): Promise<void> => {
    if (!req.userContext || !req.userContext.userId) {
      return next(new AuthenticationException('User context missing. Must authenticate first.'));
    }

    const currentUserRole = req.userContext.role || req.userContext.accountType;
    if (currentUserRole === 'admin' || currentUserRole === 'ADMIN') {
      return next();
    }

    const targetSupplierId =
      req.params[supplierIdParam] || req.body[supplierIdParam] || req.query[supplierIdParam];
    if (!targetSupplierId) {
      return next();
    }

    const user = await UserModel.findById(req.userContext.userId).lean();
    if (!user || (!user.supplierId && user.role !== 'admin')) {
      return next(
        new AuthorizationException('Forbidden: User does not belong to a supplier organization.'),
      );
    }

    if (user.supplierId !== targetSupplierId) {
      return next(
        new AuthorizationException(
          'Organization Boundary Violation: You cannot access or modify resources belonging to another supplier.',
        ),
      );
    }

    next();
  };
};
