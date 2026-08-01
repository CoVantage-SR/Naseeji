import { Server } from 'http';
import { MongoConnectionManager } from '../database/mongo/connection-manager.js';
import { WinstonLogger } from '../core/logger/winston.logger.js';

export const setupGracefulShutdown = (server: Server): void => {
  const logger = WinstonLogger.getInstance();

  const shutdown = async (signal: string) => {
    logger.info(`Received ${signal}. Starting Graceful Shutdown...`);

    server.close(async () => {
      logger.info('HTTP Server closed.');
      try {
        await MongoConnectionManager.disconnect();
        logger.info('Graceful shutdown completed successfully.');
        process.exit(0);
      } catch (error) {
        logger.error('Error during database disconnect in shutdown:', {
          error: (error as Error).message,
        });
        process.exit(1);
      }
    });

    // Force exit after 10 seconds timeout
    setTimeout(() => {
      logger.error('Forced shutdown due to timeout.');
      process.exit(1);
    }, 10000);
  };

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));

  process.on('unhandledRejection', (reason) => {
    logger.error('Unhandled Promise Rejection:', { reason });
  });

  process.on('uncaughtException', (error) => {
    logger.error('Uncaught Exception:', { error: error.message, stack: error.stack });
    process.exit(1);
  });
};
