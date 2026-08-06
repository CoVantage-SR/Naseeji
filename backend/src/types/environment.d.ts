declare namespace NodeJS {
  interface ProcessEnv {
    NODE_ENV: 'development' | 'testing' | 'production' | 'test';
    PORT: string;
    API_PREFIX: string;
    MONGODB_URI: string;
    MONGODB_MIN_POOL_SIZE?: string;
    MONGODB_MAX_POOL_SIZE?: string;
    LOG_LEVEL?: string;
    LOG_DIR?: string;
    CORS_ORIGIN?: string;
    RATE_LIMIT_WINDOW_MS?: string;
    RATE_LIMIT_MAX_REQUESTS?: string;
  }
}
