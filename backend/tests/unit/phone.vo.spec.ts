import { Phone } from '../../src/modules/auth/identity/domain/value-objects/phone.vo';
import { InvalidPhoneException } from '../../src/modules/auth/domain/errors/auth-domain.exceptions';

describe('Phone Value Object Unit Tests', () => {
  it('should create a valid E.164 phone number', () => {
    const phone = Phone.create('+966500000000');
    expect(phone.value).toBe('+966500000000');
  });

  it('should throw InvalidPhoneException for non-E.164 numbers', () => {
    expect(() => Phone.create('0500000000')).toThrow(InvalidPhoneException);
    expect(() => Phone.create('invalid-phone')).toThrow(InvalidPhoneException);
  });
});
