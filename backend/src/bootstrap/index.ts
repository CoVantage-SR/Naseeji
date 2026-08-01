import { Express } from 'express';
import { bootstrapEnv } from './env.bootstrap.js';
import { bootstrapLogger } from './logger.bootstrap.js';
import { bootstrapDI } from './di.bootstrap.js';
import { bootstrapDatabase } from './database.bootstrap.js';
import { bootstrapExpress } from './express.bootstrap.js';
import { AppConfig } from '../config/index.js';
import { WinstonLogger } from '../core/logger/winston.logger.js';

export interface BootstrapResult {
  app: Express;
  config: AppConfig;
  logger: WinstonLogger;
}

export class MasterBootstrapper {
  public static async bootstrap(): Promise<BootstrapResult> {
    // 1. Environment & Config Validation
    const config = bootstrapEnv();

    // 2. Logger Initialization
    const logger = bootstrapLogger(config.logger);
    logger.info('Initializing NASEEJI Backend Enterprise Foundation...');

    // 3. DI Container Setup
    bootstrapDI();
    logger.info('DI Container Registered.');

    // 4. Database Connection & Index Loading
    await bootstrapDatabase(config.database);

    // 5. Express Application Setup & Security
    const app = bootstrapExpress(config);
    logger.info('Express Security & Routes Configured.');

    return { app, config, logger };
  }
}
