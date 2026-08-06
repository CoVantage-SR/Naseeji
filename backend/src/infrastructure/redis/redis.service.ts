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

    try {
      logger.info('Attempting Redis connection...');
      this.client = new Redis(redisUrl, {
        maxRetriesPerRequest: 1,
        lazyConnect: true,
        retryStrategy(times: number): number | null {
          if (times > 3) {
            logger.warn('Redis unavailable locally. Operating in fallback mode.');
            return null;
          }
          const delay = Math.min(times * 200, 1000);
          logger.warn(`Redis connection retry #${times} in ${delay}ms`);
          return delay;
        },
      });

      this.client.on('connect', () => {
        this.isConnected = true;
        logger.info('Redis Connection Established Successfully.');
      });

      this.client.on('error', (err) => {
        if (!this.isConnected) {
          // Suppress noise when server isn't running locally
          return;
        }
        logger.error('Redis Runtime Connection Error:', { error: err.message });
      });

      this.client.on('end', () => {
        this.isConnected = false;
      });

      await this.client.connect();
      await this.client.ping();
      this.isConnected = true;
    } catch (error) {
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
