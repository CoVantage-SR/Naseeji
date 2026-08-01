import { UuidUtil } from '../../../../core/utils/uuid.util.js';

export class PermissionId {
  private readonly _value: string;

  private constructor(value: string) {
    this._value = value;
  }

  public static create(value?: string): PermissionId {
    const id = value || UuidUtil.generate();
    if (!UuidUtil.isValid(id)) {
      throw new Error(`Invalid PermissionId UUID: ${id}`);
    }
    return new PermissionId(id);
  }

  public get value(): string {
    return this._value;
  }
}
