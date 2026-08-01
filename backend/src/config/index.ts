import { validateEnv, EnvConfig } from './env.config.js';
import { getDatabaseConfig, DatabaseConfig } from './database.config.js';
import { getLoggerConfig, LoggerConfig } from './logger.config.js';
import { getSecurityConfig, SecurityConfig } from './security.config.js';

export interface AppConfig {
  env: EnvConfig;
  database: DatabaseConfig;
  logger: LoggerConfig;
  security: SecurityConfig;
}

export const loadConfig = (): AppConfig => {
  const env = validateEnv();
  return {
    env,
    database: getDatabaseConfig(env),
    logger: getLoggerConfig(env),
    security: getSecurityConfig(env),
  };
};

export * from './env.config.js';
export * from './database.config.js';
export * from './logger.config.js';
export * from './security.config.js';
export * from './swagger.config.js';
