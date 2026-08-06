import * as Minio from 'minio';
import { MinioConfig } from '../../config/minio.config.js';
import { WinstonLogger } from '../../core/logger/winston.logger.js';

export class MinioService {
  private static instance: MinioService;
  private client: Minio.Client | null = null;
  private bucketName = 'naseeji-uploads';
  private isInitialized = false;

  private constructor() {}

  public static getInstance(): MinioService {
    if (!MinioService.instance) {
      MinioService.instance = new MinioService();
    }
    return MinioService.instance;
  }

  public async initialize(config: MinioConfig): Promise<void> {
    const logger = WinstonLogger.getInstance();
    this.bucketName = config.bucketName;

    if (process.env.NODE_ENV === 'test') {
      logger.info('Skipping MinIO connection in test environment.');
      return;
    }

    let endPoint = config.endPoint;
    const useSSL = config.useSSL;

    try {
      logger.info(`Attempting MinIO connection to ${endPoint}:${config.port} (SSL: ${useSSL})...`);
      this.client = new Minio.Client({
        endPoint,
        port: config.port,
        useSSL,
        accessKey: config.accessKey,
        secretKey: config.secretKey,
      });

      const exists = await this.client.bucketExists(this.bucketName);
      if (!exists) {
        await this.client.makeBucket(this.bucketName);
        logger.info(`MinIO Created Bucket: "${this.bucketName}"`);
      } else {
        logger.info(`MinIO Bucket "${this.bucketName}" Verified.`);
      }

      this.isInitialized = true;
      logger.info('MinIO Service Initialized Successfully.');
    } catch (error) {
      // Fallback for local development when running outside Docker container
      if (endPoint === 'minio') {
        endPoint = '127.0.0.1';
        logger.warn(`MinIO hostname 'minio' unresolvable locally. Retrying with ${endPoint}...`);
        try {
          this.client = new Minio.Client({
            endPoint,
            port: config.port,
            useSSL: false,
            accessKey: config.accessKey,
            secretKey: config.secretKey,
          });
          const exists = await this.client.bucketExists(this.bucketName);
          if (!exists) {
            await this.client.makeBucket(this.bucketName);
          }
          this.isInitialized = true;
          logger.info('MinIO Service Initialized Successfully via local fallback.');
          return;
        } catch (fallbackError) {
          logger.error(`MinIO Initialization Error: ${(fallbackError as Error).message}`);
        }
      } else {
        logger.error(`MinIO Initialization Error: ${(error as Error).message}`);
      }
    }
  }

  public isReady(): boolean {
    return this.isInitialized;
  }

  public async checkHealth(): Promise<{ status: 'UP' | 'DOWN'; bucket?: string; error?: string }> {
    if (!this.client) {
      return { status: 'DOWN', error: 'MinIO client uninitialized' };
    }
    try {
      const exists = await this.client.bucketExists(this.bucketName);
      return { status: exists ? 'UP' : 'DOWN', bucket: this.bucketName };
    } catch (error) {
      return { status: 'DOWN', error: (error as Error).message };
    }
  }

  public getClient(): Minio.Client | null {
    return this.client;
  }
}
