import { BaseException } from './base.exception.js';
import { HttpStatus, HttpStatusCode } from '../constants/http-status.constant.js';
import { ErrorCodes, ErrorCode } from '../constants/error-codes.constant.js';

export class DatabaseException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.INTERNAL_SERVER_ERROR;
  public readonly errorCode: ErrorCode = ErrorCodes.DATABASE_ERROR;

  constructor(message = 'Database Operation Failed', errors: unknown[] = []) {
    super(message, errors);
  }
}
