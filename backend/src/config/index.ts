import { validateEnv, EnvConfig } from './env.config.js';
import { getDatabaseConfig, DatabaseConfig } from './database.config.js';
import { getLoggerConfig, LoggerConfig } from './logger.config.js';
import { getSecurityConfig, SecurityConfig } from './security.config.js';
import { getRedisConfig, RedisConfig } from './redis.config.js';
import { getMinioConfig, MinioConfig } from './minio.config.js';
import { getMailConfig, MailConfig } from './mail.config.js';

export interface AppConfig {
  env: EnvConfig;
  database: DatabaseConfig;
  logger: LoggerConfig;
  security: SecurityConfig;
  redis: RedisConfig;
  minio: MinioConfig;
  mail: MailConfig;
}

export const loadConfig = (): AppConfig => {
  const env = validateEnv();
  return {
    env,
    database: getDatabaseConfig(env),
    logger: getLoggerConfig(env),
    security: getSecurityConfig(env),
    redis: getRedisConfig(env),
    minio: getMinioConfig(env),
    mail: getMailConfig(env),
  };
};

export * from './env.config.js';
export * from './database.config.js';
export * from './logger.config.js';
export * from './security.config.js';
export * from './redis.config.js';
export * from './minio.config.js';
export * from './mail.config.js';
export * from './swagger.config.js';
