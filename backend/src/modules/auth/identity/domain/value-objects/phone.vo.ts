import { InvalidPhoneException } from '../../../domain/errors/auth-domain.exceptions.js';

export class Phone {
  private readonly _value: string;

  private constructor(value: string) {
    this._value = value;
  }

  public static create(value: string): Phone {
    if (!value || typeof value !== 'string') {
      throw new InvalidPhoneException('Phone number is required');
    }

    const trimmed = value.trim();
    const e164Regex = /^\+[1-9]\d{6,14}$/;
    if (!e164Regex.test(trimmed)) {
      throw new InvalidPhoneException(
        `Invalid phone number format: "${trimmed}". Must follow E.164 standards (e.g. +966500000000)`,
      );
    }

    return new Phone(trimmed);
  }

  public get value(): string {
    return this._value;
  }

  public equals(other: Phone): boolean {
    return this._value === other.value;
  }
}
