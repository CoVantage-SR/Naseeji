import { EnvConfig } from './env.config.js';

export interface SecurityConfig {
  corsOrigin: string;
  rateLimitWindowMs: number;
  rateLimitMaxRequests: number;
}

export const getSecurityConfig = (env: EnvConfig): SecurityConfig => ({
  corsOrigin: env.CORS_ORIGIN,
  rateLimitWindowMs: env.RATE_LIMIT_WINDOW_MS,
  rateLimitMaxRequests: env.RATE_LIMIT_MAX_REQUESTS,
});
