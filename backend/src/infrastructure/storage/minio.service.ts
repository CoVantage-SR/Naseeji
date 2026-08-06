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

    try {
      logger.info(`Attempting MinIO connection to ${config.endPoint}:${config.port}...`);
      this.client = new Minio.Client({
        endPoint: config.endPoint,
        port: config.port,
        useSSL: config.useSSL,
        accessKey: config.accessKey,
        secretKey: config.secretKey,
      });

      // Ensure target bucket exists
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
      logger.error(`MinIO Initialization Error: ${(error as Error).message}`);
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
