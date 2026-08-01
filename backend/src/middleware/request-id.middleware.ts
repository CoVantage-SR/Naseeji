import { Request, Response, NextFunction } from 'express';
import { UuidUtil } from '../core/utils/uuid.util.js';
import { RequestContext } from '../core/context/request-context.js';

export const requestIdMiddleware = (req: Request, res: Response, next: NextFunction): void => {
  const traceId = (req.headers['x-request-id'] as string) || UuidUtil.generate();
  req.traceId = traceId;
  req.startTime = Date.now();
  res.setHeader('X-Request-ID', traceId);

  RequestContext.run({ traceId, startTime: req.startTime }, () => {
    next();
  });
};
