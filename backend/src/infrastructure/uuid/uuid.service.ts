import { UuidUtil } from '../../core/utils/uuid.util.js';

export interface IUuidService {
  generate(): string;
  validate(id: string): boolean;
}

export class UuidService implements IUuidService {
  public generate(): string {
    return UuidUtil.generate();
  }

  public validate(id: string): boolean {
    return UuidUtil.isValid(id);
  }
}
