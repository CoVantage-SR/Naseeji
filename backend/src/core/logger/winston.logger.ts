import winston from 'winston';
import 'winston-daily-rotate-file';
import path from 'path';
import fs from 'fs';
import { LoggerConfig } from '../../config/logger.config.js';

export interface ILogger {
  info(message: string, meta?: Record<string, unknown>): void;
  error(message: string, meta?: Record<string, unknown>): void;
  warn(message: string, meta?: Record<string, unknown>): void;
  debug(message: string, meta?: Record<string, unknown>): void;
  http(message: string, meta?: Record<string, unknown>): void;
}

export class WinstonLogger implements ILogger {
  private static instance: WinstonLogger;
  private logger!: winston.Logger;

  private constructor(config: LoggerConfig) {
    const logDir = path.resolve(process.cwd(), config.dir);
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }

    const logFormat = winston.format.combine(
      winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
      winston.format.errors({ stack: true }),
      winston.format.splat(),
      winston.format.json(),
    );

    const consoleFormat = winston.format.combine(
      winston.format.colorize({ all: true }),
      winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
      winston.format.printf(
        ({ timestamp, level, message, ...meta }) =>
          `[${timestamp}] [${level}]: ${message} ${
            Object.keys(meta).length ? JSON.stringify(meta, null, 2) : ''
          }`,
      ),
    );

    const transports: winston.transport[] = [
      new winston.transports.Console({
        level: config.level,
        format: consoleFormat,
      }),
    ];

    if (process.env.NODE_ENV !== 'test' && process.env.NODE_ENV !== 'testing') {
      transports.push(
        new winston.transports.DailyRotateFile({
          dirname: logDir,
          filename: 'application-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          zippedArchive: true,
          maxSize: '20m',
          maxFiles: '14d',
          level: config.level,
          format: logFormat,
        }),
        new winston.transports.DailyRotateFile({
          dirname: path.join(logDir, 'errors'),
          filename: 'error-%DATE%.log',
          datePattern: 'YYYY-MM-DD',
          zippedArchive: true,
          maxSize: '20m',
          maxFiles: '30d',
          level: 'error',
          format: logFormat,
        }),
      );
    }

    this.logger = winston.createLogger({
      level: config.level,
      format: logFormat,
      transports,
      exitOnError: false,
    });
  }

  public static initialize(config: LoggerConfig): WinstonLogger {
    if (!WinstonLogger.instance) {
      WinstonLogger.instance = new WinstonLogger(config);
    }
    return WinstonLogger.instance;
  }

  public static getInstance(): WinstonLogger {
    if (!WinstonLogger.instance) {
      throw new Error('WinstonLogger has not been initialized. Call initialize() first.');
    }
    return WinstonLogger.instance;
  }

  public info(message: string, meta?: Record<string, unknown>): void {
    this.logger.info(message, meta);
  }

  public error(message: string, meta?: Record<string, unknown>): void {
    this.logger.error(message, meta);
  }

  public warn(message: string, meta?: Record<string, unknown>): void {
    this.logger.warn(message, meta);
  }

  public debug(message: string, meta?: Record<string, unknown>): void {
    this.logger.debug(message, meta);
  }

  public http(message: string, meta?: Record<string, unknown>): void {
    this.logger.http(message, meta);
  }
}
