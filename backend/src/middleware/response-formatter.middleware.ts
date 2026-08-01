import { Request, Response, NextFunction } from 'express';
import { ApiResponseBuilder } from '../shared/response/api-response.builder.js';

export const responseFormatterMiddleware = (
  _req: Request,
  res: Response,
  next: NextFunction,
): void => {
  res.success = function <T>(data: T, message = 'Success', statusCode = 200): Response {
    const formattedResponse = ApiResponseBuilder.success(data, message);
    return res.status(statusCode).json(formattedResponse);
  };
  next();
};

declare global {
  namespace Express {
    interface Response {
      success<T>(data: T, message?: string, statusCode?: number): Response;
    }
  }
}
