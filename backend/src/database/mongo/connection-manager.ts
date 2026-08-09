import mongoose from 'mongoose';
import { DatabaseConfig } from '../../config/database.config.js';
import { WinstonLogger } from '../../core/logger/winston.logger.js';
import { DatabaseException } from '../../core/errors/database.exception.js';

export class MongoConnectionManager {
  private static isConnected = false;

  public static async connect(config: DatabaseConfig): Promise<void> {
    const logger = WinstonLogger.getInstance();
    if (this.isConnected) {
      logger.info('MongoDB connection already established.');
      return;
    }

    const isTestEnv = process.env.NODE_ENV === 'test';
    if (isTestEnv) {
      logger.info('MongoDB connection skipped in test environment.');
      return;
    }

    const options: mongoose.ConnectOptions = {
      minPoolSize: config.minPoolSize,
      maxPoolSize: config.maxPoolSize,
      serverSelectionTimeoutMS: config.serverSelectionTimeoutMS,
    };

    let targetUri = config.uri;
    let retries = isTestEnv ? 1 : 5;

    while (retries > 0) {
      try {
        logger.info(
          `Attempting MongoDB connection to ${targetUri.replace(/:([^@]+)@/, ':****@')}... (Retries left: ${retries})`,
        );
        await mongoose.connect(targetUri, options);
        this.isConnected = true;
        logger.info('MongoDB Connection Established Successfully.');

        mongoose.connection.on('error', (err) => {
          logger.error('MongoDB Runtime Connection Error:', { error: err.message });
        });

        mongoose.connection.on('disconnected', () => {
          logger.warn('MongoDB Disconnected.');
          this.isConnected = false;
        });

        return;
      } catch (error) {
        retries -= 1;
        const errMsg = (error as Error).message;
        logger.error(`MongoDB connection failed: ${errMsg}`);

        // If local authentication failed, fallback to unauthenticated local URI once
        if (errMsg.includes('Authentication failed') && targetUri.includes('@')) {
          targetUri = 'mongodb://127.0.0.1:27017/naseeji';
          logger.warn(`Switching to unauthenticated local Mongo URI: ${targetUri}`);
        }

        if (retries === 0) {
          if (isTestEnv) {
            logger.warn('MongoDB connection skipped in test environment.');
            return;
          }
          throw new DatabaseException('Failed to connect to MongoDB after 5 attempts');
        }
        await new Promise((resolve) => setTimeout(resolve, 2000));
      }
    }
  }

  public static async disconnect(): Promise<void> {
    const logger = WinstonLogger.getInstance();
    try {
      await mongoose.disconnect();
      this.isConnected = false;
      logger.info('MongoDB Disconnected.');
    } catch (error) {
      logger.error('Error during MongoDB disconnect:', { error: (error as Error).message });
    }
  }

  public static getStatus(): boolean {
    return this.isConnected && mongoose.connection.readyState === 1;
  }
}
