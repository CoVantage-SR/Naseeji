import { Request, Response, NextFunction } from 'express';
import { BaseException } from '../core/errors/base.exception.js';
import { WinstonLogger } from '../core/logger/winston.logger.js';
import { ApiResponseBuilder } from '../shared/response/api-response.builder.js';
import { HttpStatus } from '../core/constants/http-status.constant.js';

export const globalErrorHandlerMiddleware = (
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
): Response => {
  const logger = WinstonLogger.getInstance();

  if (err instanceof BaseException) {
    logger.warn(`Handled Exception [${err.errorCode}]: ${err.message}`, {
      statusCode: err.statusCode,
      errors: err.errors,
      stack: err.stack,
    });

    const formattedResponse = ApiResponseBuilder.error(
      err.message,
      err.errors.length > 0 ? err.errors : null,
    );
    return res.status(err.statusCode).json(formattedResponse);
  }

  // Unhandled internal error
  logger.error(`Unhandled Internal Error: ${err.message}`, {
    error: err.message,
    stack: err.stack,
  });

  const formattedResponse = ApiResponseBuilder.error('Internal Server Error', null);
  return res.status(HttpStatus.INTERNAL_SERVER_ERROR).json(formattedResponse);
};
