import { BaseException } from './base.exception.js';
import { HttpStatus, HttpStatusCode } from '../constants/http-status.constant.js';
import { ErrorCodes, ErrorCode } from '../constants/error-codes.constant.js';

export class AuthorizationException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.FORBIDDEN;
  public readonly errorCode: ErrorCode = ErrorCodes.FORBIDDEN;

  constructor(message = 'Access Denied', errors: unknown[] = []) {
    super(message, errors);
  }
}
