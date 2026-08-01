import { UuidUtil } from '../../../../core/utils/uuid.util.js';

export class RoleId {
  private readonly _value: string;

  private constructor(value: string) {
    this._value = value;
  }

  public static create(value?: string): RoleId {
    const id = value || UuidUtil.generate();
    if (!UuidUtil.isValid(id)) {
      throw new Error(`Invalid RoleId UUID: ${id}`);
    }
    return new RoleId(id);
  }

  public get value(): string {
    return this._value;
  }
}
