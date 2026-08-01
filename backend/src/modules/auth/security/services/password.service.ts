import { BcryptService } from '../../../../infrastructure/encryption/bcrypt.service.js';
import { Password } from '../../identity/domain/value-objects/password.vo.js';

export class PasswordService {
  private bcryptService: BcryptService;

  constructor() {
    this.bcryptService = new BcryptService();
  }

  public async hashPassword(password: Password): Promise<Password> {
    if (password.isHashed) return password;
    const hashed = await this.bcryptService.hash(password.value);
    return Password.createHashed(hashed);
  }

  public async verifyPassword(plainPassword: Password, hashedPassword: Password): Promise<boolean> {
    return this.bcryptService.compare(plainPassword.value, hashedPassword.value);
  }
}
