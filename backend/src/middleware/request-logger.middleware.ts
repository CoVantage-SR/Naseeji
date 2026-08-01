import { Request, Response, NextFunction } from 'express';
import { WinstonLogger } from '../core/logger/winston.logger.js';

export const requestLoggerMiddleware = (
  req: Request,
  res: Response,
  next: NextFunction,
): void => {
  const logger = WinstonLogger.getInstance();
  const { method, originalUrl, ip } = req;

  res.on('finish', () => {
    const { statusCode } = res;
    const duration = req.startTime ? Date.now() - req.startTime : 0;

    logger.info(`HTTP ${method} ${originalUrl} ${statusCode} - ${duration}ms`, {
      traceId: req.traceId,
      method,
      url: originalUrl,
      statusCode,
      duration: `${duration}ms`,
      ip,
    });
  });

  next();
};
