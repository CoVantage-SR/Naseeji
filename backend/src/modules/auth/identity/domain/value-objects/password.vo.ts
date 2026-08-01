import { WeakPasswordException } from '../../../domain/errors/auth-domain.exceptions.js';

export class Password {
  private readonly _value: string;
  private readonly _isHashed: boolean;

  private constructor(value: string, isHashed: boolean) {
    this._value = value;
    this._isHashed = isHashed;
  }

  public static createPlain(plainText: string): Password {
    if (!plainText || plainText.length < 8) {
      throw new WeakPasswordException('Password must be at least 8 characters long');
    }

    const hasUppercase = /[A-Z]/.test(plainText);
    const hasLowercase = /[a-z]/.test(plainText);
    const hasDigit = /\d/.test(plainText);
    const hasSpecial = /[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/.test(plainText);

    if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecial) {
      throw new WeakPasswordException(
        'Password must contain at least 1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character',
      );
    }

    return new Password(plainText, false);
  }

  public static createHashed(hashedText: string): Password {
    if (!hashedText) {
      throw new Error('Hashed password cannot be empty');
    }
    return new Password(hashedText, true);
  }

  public get value(): string {
    return this._value;
  }

  public get isHashed(): boolean {
    return this._isHashed;
  }
}
