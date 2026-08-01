import { container } from '../core/di/container.js';
import { UuidService } from '../infrastructure/uuid/uuid.service.js';
import { BcryptService } from '../infrastructure/encryption/bcrypt.service.js';
import { WinstonLogger } from '../core/logger/winston.logger.js';

export const bootstrapDI = (): void => {
  container.registerSingleton('Logger', WinstonLogger.getInstance());
  container.registerSingleton('UuidService', new UuidService());
  container.registerSingleton('HashService', new BcryptService());
};
