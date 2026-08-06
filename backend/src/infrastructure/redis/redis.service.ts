import Redis from 'ioredis';
import { WinstonLogger } from '../../core/logger/winston.logger.js';

export class RedisService {
  private static instance: RedisService;
  private client: Redis | null = null;
  private isConnected = false;

  private constructor() {}

  public static getInstance(): RedisService {
    if (!RedisService.instance) {
      RedisService.instance = new RedisService();
    }
    return RedisService.instance;
  }

  public async connect(redisUrl: string): Promise<void> {
    const logger = WinstonLogger.getInstance();
    if (this.isConnected && this.client) {
      return;
    }

    if (process.env.NODE_ENV === 'test') {
      logger.info('Skipping Redis connection in test environment.');
      return;
    }

    let targetUrl = redisUrl;
    try {
      logger.info('Attempting Redis connection...');
      this.client = new Redis(targetUrl, {
        maxRetriesPerRequest: 1,
        lazyConnect: true,
        connectTimeout: 2000,
        retryStrategy(times: number): number | null {
          if (times > 2) {
            return null;
          }
          return 200;
        },
      });

      this.client.on('connect', () => {
        this.isConnected = true;
        logger.info('Redis Connection Established Successfully.');
      });

      this.client.on('error', (err) => {
        if (!this.isConnected) return;
        logger.error('Redis Runtime Connection Error:', { error: err.message });
      });

      this.client.on('end', () => {
        this.isConnected = false;
      });

      await this.client.connect();
      await this.client.ping();
      this.isConnected = true;
    } catch (error) {
      // If docker container hostname '@redis:6379' fails locally, try 127.0.0.1:6379
      if (targetUrl.includes('@redis:6379')) {
        targetUrl = targetUrl.replace('@redis:6379', '@127.0.0.1:6379');
        logger.warn(`Redis hostname 'redis' unresolvable locally. Retrying with 127.0.0.1:6379...`);
        try {
          this.client = new Redis(targetUrl, {
            maxRetriesPerRequest: 1,
            lazyConnect: true,
            connectTimeout: 2000,
          });
          await this.client.connect();
          await this.client.ping();
          this.isConnected = true;
          logger.info('Redis Connection Established Successfully via 127.0.0.1.');
          return;
        } catch (fallbackError) {
          logger.warn(
            `Redis not available locally (${(fallbackError as Error).message}). Operating in fallback mode.`,
          );
          if (this.client) {
            this.client.disconnect();
            this.client = null;
          }
          return;
        }
      }

      logger.warn(
        `Redis not available locally (${(error as Error).message}). Continuing in fallback mode.`,
      );
      if (this.client) {
        this.client.disconnect();
        this.client = null;
      }
    }
  }

  public getClient(): Redis | null {
    return this.isConnected ? this.client : null;
  }

  public async checkHealth(): Promise<{
    status: 'UP' | 'DOWN';
    latencyMs?: number;
    error?: string;
  }> {
    if (!this.client || !this.isConnected) {
      return { status: 'DOWN', error: 'Redis client disconnected' };
    }
    try {
      const start = Date.now();
      await this.client.ping();
      const latencyMs = Date.now() - start;
      return { status: 'UP', latencyMs };
    } catch (error) {
      return { status: 'DOWN', error: (error as Error).message };
    }
  }

  public async disconnect(): Promise<void> {
    if (this.client) {
      await this.client.quit();
      this.client = null;
      this.isConnected = false;
    }
  }
}
