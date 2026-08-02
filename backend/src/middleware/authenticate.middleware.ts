import { Request, Response, NextFunction } from 'express';
import { JwtService } from '../modules/auth/security/services/jwt.service.js';
import { AuthenticationException } from '../core/errors/auth.exception.js';

export interface UserContext {
  userId: string;
  sessionId: string;
  accountType: string;
  roles: string[];
}

export const authenticateMiddleware = (
  req: Request,
  _res: Response,
  next: NextFunction,
): void => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next(new AuthenticationException('Missing or invalid Authorization header'));
  }

  const token = authHeader.substring(7);
  try {
    const jwtService = new JwtService();
    const payload = jwtService.verifyToken(token);

    req.userContext = {
      userId: payload.sub,
      sessionId: payload.sessionId,
      accountType: payload.accountType,
      roles: payload.roles || [],
    };

    next();
  } catch (error) {
    next(new AuthenticationException('Access Token is invalid or has expired'));
  }
};

/* eslint-disable @typescript-eslint/no-namespace */
declare global {
  namespace Express {
    interface Request {
      userContext?: UserContext;
    }
  }
}
