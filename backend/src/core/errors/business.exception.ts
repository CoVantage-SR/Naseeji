import { BaseException } from './base.exception.js';
import { HttpStatus, HttpStatusCode } from '../constants/http-status.constant.js';
import { ErrorCodes, ErrorCode } from '../constants/error-codes.constant.js';

export class BusinessException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.UNPROCESSABLE_ENTITY;
  public readonly errorCode: ErrorCode = ErrorCodes.BUSINESS_ERROR;

  constructor(message = 'Business Logic Constraint Violated', errors: unknown[] = []) {
    super(message, errors);
  }
}
