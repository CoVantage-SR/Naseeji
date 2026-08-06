import { EnvConfig } from './env.config.js';

export interface RedisConfig {
  url: string;
}

export const getRedisConfig = (env: EnvConfig): RedisConfig => ({
  url: env.REDIS_URL,
});
