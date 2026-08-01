import { HttpStatusCode } from '../constants/http-status.constant.js';
import { ErrorCode } from '../constants/error-codes.constant.js';

export abstract class BaseException extends Error {
  public abstract readonly statusCode: HttpStatusCode;
  public abstract readonly errorCode: ErrorCode;
  public readonly errors: unknown[];

  constructor(message: string, errors: unknown[] = []) {
    super(message);
    Object.setPrototypeOf(this, new.target.prototype);
    this.errors = errors;
    Error.captureStackTrace(this, this.constructor);
  }
}
