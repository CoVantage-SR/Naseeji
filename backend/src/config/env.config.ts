import { z } from 'zod';
import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'testing', 'production', 'test']).default('development'),
  PORT: z.coerce.number().default(5000),
  API_PREFIX: z.string().default('/api/v1'),
  MONGODB_URI: z.string().default('mongodb://127.0.0.1:27017/naseeji'),
  MONGODB_MIN_POOL_SIZE: z.coerce.number().default(5),
  MONGODB_MAX_POOL_SIZE: z.coerce.number().default(20),
  REDIS_URL: z.string().default('redis://:redis123@redis:6379'),
  MINIO_ENDPOINT: z.string().default('minio'),
  MINIO_PORT: z.coerce.number().default(9000),
  MINIO_USE_SSL: z
    .union([z.boolean(), z.string()])
    .transform((val) => val === true || val === 'true')
    .default(false),
  MINIO_ACCESS_KEY: z.string().default('minioadmin'),
  MINIO_SECRET_KEY: z.string().default('minioadmin123'),
  MINIO_BUCKET_NAME: z.string().default('naseeji-uploads'),
  JWT_SECRET: z.string().default('naseeji-enterprise-super-secret-jwt-key-2026'),
  JWT_REFRESH_SECRET: z.string().default('naseeji-enterprise-super-secret-refresh-key-2026'),
  JWT_ACCESS_TTL: z.string().default('15m'),
  JWT_REFRESH_TTL: z.string().default('30d'),
  FRONTEND_URL: z.string().default('http://localhost:3000'),
  API_URL: z.string().default('http://localhost:5000/api/v1'),
  LOG_LEVEL: z.string().default('info'),
  LOG_DIR: z.string().default('logs'),
  CORS_ORIGIN: z.string().default('*'),
  RATE_LIMIT_WINDOW_MS: z.coerce.number().default(900000),
  RATE_LIMIT_MAX_REQUESTS: z.coerce.number().default(100),
  SMTP_HOST: z.string().default('127.0.0.1'),
  SMTP_PORT: z.coerce.number().default(1025),
  SMTP_SECURE: z
    .union([z.boolean(), z.string()])
    .transform((val) => val === true || val === 'true')
    .default(false),
  SMTP_USER: z.string().optional(),
  SMTP_PASS: z.string().optional(),
  MAIL_FROM: z.string().default('noreply@naseeji.com'),
  // OTP security configuration
  OTP_TTL_SECONDS: z.coerce.number().default(300),
  OTP_MAX_ATTEMPTS: z.coerce.number().default(5),
  OTP_RESEND_COOLDOWN_SECONDS: z.coerce.number().default(60),
  PASSWORD_HASH_ROUNDS: z.coerce.number().default(12),
  // Google OAuth
  GOOGLE_CLIENT_ID: z.string().optional(),
  // WhatsApp Meta API
  WHATSAPP_API_TOKEN: z.string().optional(),
  WHATSAPP_PHONE_NUMBER_ID: z.string().optional(),
  WHATSAPP_API_URL: z.string().default('https://graph.facebook.com/v19.0'),
  // Legacy Meta env aliases (kept for backward compatibility)
  META_WHATSAPP_TOKEN: z.string().optional(),
  META_WHATSAPP_PHONE_ID: z.string().optional(),
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
