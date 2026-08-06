import { WinstonLogger } from '../../core/logger/winston.logger.js';
import { UserModel } from '../../modules/auth/infrastructure/database/user.schema.js';
import { FactoryModel } from '../../modules/auth/infrastructure/database/factory.schema.js';
import { SupplierModel } from '../../modules/auth/infrastructure/database/supplier.schema.js';
import { WalletModel } from '../../modules/auth/infrastructure/database/wallet.schema.js';
import { DeviceModel } from '../../modules/auth/infrastructure/database/device.schema.js';
import { SessionModel } from '../../modules/auth/infrastructure/database/session.schema.js';
import { RefreshTokenModel } from '../../modules/auth/infrastructure/database/refresh-token.schema.js';
import { OtpModel } from '../../modules/auth/infrastructure/database/otp.schema.js';
import { SecurityLogModel } from '../../modules/auth/infrastructure/database/security-log.schema.js';
import { VerificationRequestModel } from '../../modules/auth/infrastructure/database/verification-request.schema.js';
import { RoleModel } from '../../modules/auth/infrastructure/database/role.schema.js';
import { PermissionModel } from '../../modules/auth/infrastructure/database/permission.schema.js';

export class MongoIndexLoader {
  public static async loadIndexes(): Promise<void> {
    const logger = WinstonLogger.getInstance();

    if (process.env.NODE_ENV === 'test') {
      logger.info('Skipping MongoDB index creation in test environment.');
      return;
    }

    try {
      const models = [
        UserModel,
        FactoryModel,
        SupplierModel,
        WalletModel,
        DeviceModel,
        SessionModel,
        RefreshTokenModel,
        OtpModel,
        SecurityLogModel,
        VerificationRequestModel,
        RoleModel,
        PermissionModel,
      ];

      for (const model of models) {
        await model.createCollection();
        await model.syncIndexes();
      }

      logger.info(
        `MongoDB Collections & Indexes Successfully Synchronized (${models.length} collections).`,
      );
    } catch (error) {
      logger.error(`Error loading MongoDB collections/indexes: ${(error as Error).message}`);
    }
  }
}
