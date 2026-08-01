import { v4 as uuidv4, validate as uuidValidate } from 'uuid';

export class UuidUtil {
  public static generate(): string {
    return uuidv4();
  }

  public static isValid(uuid: string): boolean {
    return uuidValidate(uuid);
  }
}
