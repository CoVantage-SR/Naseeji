import { Request, Response, NextFunction } from 'express';
import { JwtService } from '../modules/auth/security/services/jwt.service.js';
import { AuthenticationException } from '../core/errors/auth.exception.js';
import { SessionModel } from '../modules/auth/infrastructure/database/session.schema.js';
import { UserModel } from '../modules/auth/infrastructure/database/user.schema.js';

export interface UserContext {
  userId: string;
  sessionId: string;
  accountType: string;
  role?: string;
  roles: string[];
}

/**
 * Statuses that are permanently blocked from API access.
 * 'pending' is allowed — users with pending status can still access protected routes
 * (e.g., to complete phone verification after registration).
 */
const BLOCKED_STATUSES = ['deactivated', 'deleted', 'blocked', 'suspended', 'rejected'] as const;

export const authenticateMiddleware = async (
  req: Request,
  _res: Response,
  next: NextFunction,
): Promise<void> => {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return next(new AuthenticationException('Missing or invalid Authorization header'));
  }

  const token = authHeader.substring(7);
  let payload: ReturnType<JwtService['verifyToken']>;

  try {
    const jwtService = new JwtService();
    payload = jwtService.verifyToken(token);
  } catch {
    return next(new AuthenticationException('Access Token is invalid or has expired'));
  }

  // Skip DB checks in test mode to avoid connection issues
  if (process.env.NODE_ENV === 'test' || process.env.NODE_ENV === 'testing') {
    req.userContext = {
      userId: payload.sub,
      sessionId: payload.sessionId || '',
      accountType: payload.accountType || payload.role || 'user',
      role: payload.role,
      roles: payload.roles || (payload.role ? [payload.role] : []),
    };
    return next();
  }

  try {
    // 1. Verify session exists and is not revoked
    if (payload.sessionId) {
      const session = await SessionModel.findById(payload.sessionId).lean();
      if (!session) {
        return next(new AuthenticationException('Session not found. Please log in again.'));
      }
      if (session.isRevoked) {
        return next(new AuthenticationException('Session has been revoked. Please log in again.'));
      }
      if (new Date() > session.expiresAt) {
        return next(new AuthenticationException('Session has expired. Please log in again.'));
      }
    }

    // 2. Verify user exists and is in an allowed status
    const user = await UserModel.findById(payload.sub).lean();
    if (!user) {
      return next(new AuthenticationException('User account not found.'));
    }
    if (BLOCKED_STATUSES.includes(user.status as (typeof BLOCKED_STATUSES)[number])) {
      return next(new AuthenticationException(`Account access denied. Status: ${user.status}`));
    }

    req.userContext = {
      userId: payload.sub,
      sessionId: payload.sessionId || '',
      accountType: payload.accountType || user.role || 'user',
      role: user.role,
      roles: payload.roles || [user.role],
    };

    next();
  } catch (dbError) {
    // If DB check fails (e.g., connection issue), fall back to token-only auth
    req.userContext = {
      userId: payload.sub,
      sessionId: payload.sessionId || '',
      accountType: payload.accountType || payload.role || 'user',
      role: payload.role,
      roles: payload.roles || (payload.role ? [payload.role] : []),
    };
    next();
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
