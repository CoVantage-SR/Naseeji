import { BaseException } from './base.exception.js';
import { HttpStatus, HttpStatusCode } from '../constants/http-status.constant.js';
import { ErrorCodes, ErrorCode } from '../constants/error-codes.constant.js';

export class NotFoundException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.NOT_FOUND;
  public readonly errorCode: ErrorCode = ErrorCodes.NOT_FOUND;

  constructor(message = 'Resource Not Found', errors: unknown[] = []) {
    super(message, errors);
  }
}
