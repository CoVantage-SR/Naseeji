import bcrypt from 'bcrypt';

export interface IHashService {
  hash(plainText: string, saltRounds?: number): Promise<string>;
  compare(plainText: string, hashedText: string): Promise<boolean>;
}

export class BcryptService implements IHashService {
  public async hash(plainText: string, saltRounds = 10): Promise<string> {
    return bcrypt.hash(plainText, saltRounds);
  }

  public async compare(plainText: string, hashedText: string): Promise<boolean> {
    return bcrypt.compare(plainText, hashedText);
  }
}
