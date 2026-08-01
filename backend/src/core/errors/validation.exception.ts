import { BaseException } from './base.exception.js';
import { HttpStatus, HttpStatusCode } from '../constants/http-status.constant.js';
import { ErrorCodes, ErrorCode } from '../constants/error-codes.constant.js';

export class ValidationException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.BAD_REQUEST;
  public readonly errorCode: ErrorCode = ErrorCodes.VALIDATION_ERROR;

  constructor(message = 'Validation Failed', errors: unknown[] = []) {
    super(message, errors);
  }
}
