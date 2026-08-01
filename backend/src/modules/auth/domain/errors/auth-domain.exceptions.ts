import { BaseException } from '../../../../core/errors/base.exception.js';
import { HttpStatus, HttpStatusCode } from '../../../../core/constants/http-status.constant.js';
import { ErrorCodes, ErrorCode } from '../../../../core/constants/error-codes.constant.js';

export class InvalidPhoneException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.BAD_REQUEST;
  public readonly errorCode: ErrorCode = ErrorCodes.VALIDATION_ERROR;

  constructor(message = 'Invalid phone number format. Must be E.164 format (e.g. +966500000000)') {
    super(message);
  }
}

export class WeakPasswordException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.BAD_REQUEST;
  public readonly errorCode: ErrorCode = ErrorCodes.VALIDATION_ERROR;

  constructor(
    message = 'Password does not meet complexity requirements (Min 8 chars, 1 uppercase, 1 lowercase, 1 digit, 1 special char)',
  ) {
    super(message);
  }
}

export class OtpExpiredException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.BAD_REQUEST;
  public readonly errorCode: ErrorCode = ErrorCodes.BUSINESS_ERROR;

  constructor(message = 'OTP code has expired') {
    super(message);
  }
}

export class OtpInvalidException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.BAD_REQUEST;
  public readonly errorCode: ErrorCode = ErrorCodes.BUSINESS_ERROR;

  constructor(message = 'Invalid OTP code provided') {
    super(message);
  }
}

export class SessionExpiredException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.UNAUTHORIZED;
  public readonly errorCode: ErrorCode = ErrorCodes.UNAUTHORIZED;

  constructor(message = 'Session has expired or been revoked') {
    super(message);
  }
}

export class DeviceNotTrustedException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.FORBIDDEN;
  public readonly errorCode: ErrorCode = ErrorCodes.FORBIDDEN;

  constructor(message = 'Device fingerprint changed or device is untrusted') {
    super(message);
  }
}

export class RoleNotFoundException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.NOT_FOUND;
  public readonly errorCode: ErrorCode = ErrorCodes.NOT_FOUND;

  constructor(message = 'Specified RBAC Role not found') {
    super(message);
  }
}

export class PermissionDeniedException extends BaseException {
  public readonly statusCode: HttpStatusCode = HttpStatus.FORBIDDEN;
  public readonly errorCode: ErrorCode = ErrorCodes.FORBIDDEN;

  constructor(message = 'Permission denied for requested action') {
    super(message);
  }
}
