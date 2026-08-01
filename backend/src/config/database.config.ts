import { EnvConfig } from './env.config.js';

export interface DatabaseConfig {
  uri: string;
  minPoolSize: number;
  maxPoolSize: number;
  serverSelectionTimeoutMS: number;
}

export const getDatabaseConfig = (env: EnvConfig): DatabaseConfig => ({
  uri: env.MONGODB_URI,
  minPoolSize: env.MONGODB_MIN_POOL_SIZE,
  maxPoolSize: env.MONGODB_MAX_POOL_SIZE,
  serverSelectionTimeoutMS: 5000,
});
