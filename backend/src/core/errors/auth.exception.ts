import { BaseException } from './base.exception.js';
import { HttpStatus, HttpStatusCode } from '../constants/http-status.constant.js';
import { ErrorCodes, ErrorCode } from '../constants/error-codes.constant.js';

export class AuthenticationException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.UNAUTHORIZED;
  public readonly errorCode: ErrorCode = ErrorCodes.UNAUTHORIZED;

  constructor(message = 'Authentication Required', errors: unknown[] = []) {
    super(message, errors);
  }
}
