import { UuidUtil } from '@core/utils/uuid.util.js';

export class SessionId {
  private readonly _value: string;

  private constructor(value: string) {
    this._value = value;
  }

  public static create(value?: string): SessionId {
    const id = value || UuidUtil.generate();
    if (!UuidUtil.isValid(id)) {
      throw new Error(`Invalid SessionId UUID: ${id}`);
    }
    return new SessionId(id);
  }

  public get value(): string {
    return this._value;
  }
}
