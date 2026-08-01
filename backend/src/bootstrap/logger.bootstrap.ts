import { WinstonLogger } from '../core/logger/winston.logger.js';
import { LoggerConfig } from '../config/logger.config.js';

export const bootstrapLogger = (config: LoggerConfig): WinstonLogger => {
  return WinstonLogger.initialize(config);
};
