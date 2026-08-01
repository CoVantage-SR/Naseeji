import { OtpInvalidException } from '../../domain/errors/auth-domain.exceptions.js';

export class OtpCode {
  private readonly _value: string;

  private constructor(value: string) {
    this._value = value;
  }

  public static generate(length = 6): OtpCode {
    const min = Math.pow(10, length - 1);
    const max = Math.pow(10, length) - 1;
    const num = Math.floor(Math.random() * (max - min + 1)) + min;
    return new OtpCode(num.toString());
  }

  public static create(value: string): OtpCode {
    if (!value || typeof value !== 'string' || value.length !== 6 || !/^\d{6}$/.test(value)) {
      throw new OtpInvalidException('OTP code must be a 6-digit numeric string');
    }
    return new OtpCode(value);
  }

  public get value(): string {
    return this._value;
  }
}
