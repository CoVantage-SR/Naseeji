import { ValidationException } from '../../src/core/errors/validation.exception';
import { NotFoundException } from '../../src/core/errors/not-found.exception';
import { HttpStatus } from '../../src/core/constants/http-status.constant';
import { ErrorCodes } from '../../src/core/constants/error-codes.constant';

describe('Custom Exception Hierarchy Unit Tests', () => {
  it('ValidationException should have BAD_REQUEST status and VALIDATION_ERROR code', () => {
    const err = new ValidationException('Invalid payload', [
      { field: 'name', message: 'Required' },
    ]);
    expect(err.statusCode).toBe(HttpStatus.BAD_REQUEST);
    expect(err.errorCode).toBe(ErrorCodes.VALIDATION_ERROR);
    expect(err.errors.length).toBe(1);
  });

  it('NotFoundException should have NOT_FOUND status and NOT_FOUND code', () => {
    const err = new NotFoundException('User not found');
    expect(err.statusCode).toBe(HttpStatus.NOT_FOUND);
    expect(err.errorCode).toBe(ErrorCodes.NOT_FOUND);
  });
});
