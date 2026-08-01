import { Password } from '../../src/modules/auth/identity/domain/value-objects/password.vo';
import { WeakPasswordException } from '../../src/modules/auth/domain/errors/auth-domain.exceptions';

describe('Password Value Object Unit Tests', () => {
  it('should accept strong password meeting complexity policy', () => {
    const pwd = Password.createPlain('Naseeji@2026!');
    expect(pwd.value).toBe('Naseeji@2026!');
    expect(pwd.isHashed).toBe(false);
  });

  it('should throw WeakPasswordException for weak passwords', () => {
    expect(() => Password.createPlain('weak')).toThrow(WeakPasswordException);
    expect(() => Password.createPlain('12345678')).toThrow(WeakPasswordException);
  });
});
