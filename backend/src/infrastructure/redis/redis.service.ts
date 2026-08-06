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

    try {
      logger.info('Attempting Redis connection...');
      this.client = new Redis(redisUrl, {
        maxRetriesPerRequest: 3,
        retryStrategy(times: number): number {
          const delay = Math.min(times * 200, 3000);
          logger.warn(`Redis connection retry #${times} in ${delay}ms`);
          return delay;
        },
      });

      this.client.on('connect', () => {
        this.isConnected = true;
        logger.info('Redis Connection Established Successfully.');
      });

      this.client.on('error', (err) => {
        logger.error('Redis Runtime Connection Error:', { error: err.message });
      });

      this.client.on('end', () => {
        this.isConnected = false;
        logger.warn('Redis Connection Ended.');
      });

      await this.client.ping();
      this.isConnected = true;
    } catch (error) {
      logger.error(`Redis connection initial failure: ${(error as Error).message}`);
    }
  }

  public getClient(): Redis | null {
    return this.client;
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
