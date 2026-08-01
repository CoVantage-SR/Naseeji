import { UuidUtil } from '../../../../core/utils/uuid.util.js';

export class DeviceId {
  private readonly _value: string;

  private constructor(value: string) {
    this._value = value;
  }

  public static create(value?: string): DeviceId {
    const id = value || UuidUtil.generate();
    if (!UuidUtil.isValid(id)) {
      throw new Error(`Invalid DeviceId UUID: ${id}`);
    }
    return new DeviceId(id);
  }

  public get value(): string {
    return this._value;
  }
}
