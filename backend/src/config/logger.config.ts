import { EnvConfig } from './env.config.js';

export interface LoggerConfig {
  level: string;
  dir: string;
  isProduction: boolean;
}

export const getLoggerConfig = (env: EnvConfig): LoggerConfig => ({
  level: env.LOG_LEVEL,
  dir: env.LOG_DIR,
  isProduction: env.NODE_ENV === 'production',
});
