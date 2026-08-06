import { z } from 'zod';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'testing', 'production', 'test']).default('development'),
  PORT: z.coerce.number().default(5000),
  API_PREFIX: z.string().default('/api/v1'),
  MONGODB_URI: z
    .string()
    .default('mongodb://admin:admin123@mongodb:27017/naseeji?authSource=admin'),
  MONGODB_MIN_POOL_SIZE: z.coerce.number().default(5),
  MONGODB_MAX_POOL_SIZE: z.coerce.number().default(20),
  REDIS_URL: z.string().default('redis://:redis123@redis:6379'),
  MINIO_ENDPOINT: z.string().default('minio'),
  MINIO_PORT: z.coerce.number().default(9000),
  MINIO_USE_SSL: z.coerce.boolean().default(false),
  MINIO_ACCESS_KEY: z.string().default('minioadmin'),
  MINIO_SECRET_KEY: z.string().default('minioadmin123'),
  MINIO_BUCKET_NAME: z.string().default('naseeji-uploads'),
  JWT_SECRET: z.string().default('naseeji-enterprise-super-secret-jwt-key-2026'),
  JWT_REFRESH_SECRET: z.string().default('naseeji-enterprise-super-secret-refresh-key-2026'),
  FRONTEND_URL: z.string().default('http://localhost:3000'),
  API_URL: z.string().default('http://localhost:5000/api/v1'),
  LOG_LEVEL: z.string().default('info'),
  LOG_DIR: z.string().default('logs'),
  CORS_ORIGIN: z.string().default('*'),
  RATE_LIMIT_WINDOW_MS: z.coerce.number().default(900000),
  RATE_LIMIT_MAX_REQUESTS: z.coerce.number().default(100),
});

export type EnvConfig = z.infer<typeof envSchema>;

export const validateEnv = (): EnvConfig => {
  const result = envSchema.safeParse(process.env);
  if (!result.success) {
    console.error('❌ Invalid Environment Variables Configuration:');
    console.error(JSON.stringify(result.error.format(), null, 2));
    throw new Error('Environment configuration validation failed');
  }
  return result.data;
};
