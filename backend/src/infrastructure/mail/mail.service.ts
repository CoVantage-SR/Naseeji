import nodemailer from 'nodemailer';
import { MailConfig } from '../../config/mail.config.js';
import { WinstonLogger } from '../../core/logger/winston.logger.js';

export class MailService {
  private static instance: MailService;
  private transporter: nodemailer.Transporter | null = null;
  private isInitialized = false;
  private config!: MailConfig;

  private constructor() {}

  public static getInstance(): MailService {
    if (!MailService.instance) {
      MailService.instance = new MailService();
    }
    return MailService.instance;
  }

  public async initialize(config: MailConfig): Promise<void> {
    const logger = WinstonLogger.getInstance();
    this.config = config;

    if (process.env.NODE_ENV === 'test') {
      logger.info('Skipping Mailpit/SMTP connection in test environment.');
      return;
    }

    try {
      logger.info(`Attempting SMTP connection to ${config.host}:${config.port}...`);

      const auth =
        config.user && config.pass
          ? {
              user: config.user,
              pass: config.pass,
            }
          : undefined;

      this.transporter = nodemailer.createTransport({
        host: config.host,
        port: config.port,
        secure: config.secure,
        auth,
        connectionTimeout: 2000,
      });

      await this.transporter.verify();
      this.isInitialized = true;
      logger.info('Mail Service (SMTP) Initialized Successfully.');
    } catch (error) {
      // Fallback for local development when running outside Docker container
      if (config.host === 'mailpit') {
        const fallbackHost = '127.0.0.1';
        logger.warn(`SMTP hostname 'mailpit' unresolvable. Retrying with ${fallbackHost}...`);
        try {
          this.transporter = nodemailer.createTransport({
            host: fallbackHost,
            port: config.port,
            secure: false,
            connectionTimeout: 2000,
          });
          await this.transporter.verify();
          this.isInitialized = true;
          logger.info('Mail Service (SMTP) Initialized Successfully via local fallback.');
          return;
        } catch (fallbackError) {
          logger.error(`SMTP Initialization Error: ${(fallbackError as Error).message}`);
        }
      } else {
        logger.error(`SMTP Initialization Error: ${(error as Error).message}`);
      }
    }
  }

  public async checkHealth(): Promise<{ status: 'UP' | 'DOWN'; host?: string; error?: string }> {
    if (!this.transporter || !this.isInitialized) {
      return { status: 'DOWN', error: 'SMTP client uninitialized' };
    }
    try {
      await this.transporter.verify();
      return { status: 'UP', host: this.config.host };
    } catch (error) {
      return { status: 'DOWN', error: (error as Error).message };
    }
  }

  public getTransporter(): nodemailer.Transporter | null {
    return this.transporter;
  }

  public async disconnect(): Promise<void> {
    if (this.transporter) {
      this.transporter.close();
      this.transporter = null;
      this.isInitialized = false;
    }
  }
}
