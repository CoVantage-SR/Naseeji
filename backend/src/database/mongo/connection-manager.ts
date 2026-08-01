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

    const options: mongoose.ConnectOptions = {
      minPoolSize: config.minPoolSize,
      maxPoolSize: config.maxPoolSize,
      serverSelectionTimeoutMS: config.serverSelectionTimeoutMS,
    };

    let retries = 5;
    while (retries > 0) {
      try {
        logger.info(`Attempting MongoDB connection... (Retries left: ${retries})`);
        await mongoose.connect(config.uri, options);
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
        logger.error(`MongoDB connection failed: ${(error as Error).message}`);
        if (retries === 0) {
          throw new DatabaseException('Failed to connect to MongoDB after 5 attempts');
        }
        await new Promise((resolve) => setTimeout(resolve, 3000));
      }
    }
  }

  public static async disconnect(): Promise<void> {
    const logger = WinstonLogger.getInstance();
    if (!this.isConnected) return;
    try {
      await mongoose.disconnect();
      this.isConnected = false;
      logger.info('MongoDB Disconnected Gracefully.');
    } catch (error) {
      logger.error('Error during MongoDB disconnect:', { error: (error as Error).message });
    }
  }

  public static getStatus(): boolean {
    return this.isConnected && mongoose.connection.readyState === 1;
  }
}
