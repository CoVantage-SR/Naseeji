import express, { Express } from 'express';
import helmet from 'helmet';
import cors from 'cors';
import compression from 'compression';
import rateLimit from 'express-rate-limit';
import swaggerUi from 'swagger-ui-express';
import { SecurityConfig } from '../config/security.config.js';
import { getSwaggerConfig } from '../config/swagger.config.js';
import { AppConfig } from '../config/index.js';
import { requestIdMiddleware } from '../middleware/request-id.middleware.js';
import { requestLoggerMiddleware } from '../middleware/request-logger.middleware.js';
import { responseFormatterMiddleware } from '../middleware/response-formatter.middleware.js';
import { notFoundMiddleware } from '../middleware/not-found.middleware.js';
import { globalErrorHandlerMiddleware } from '../middleware/error.middleware.js';
import { appRouter } from '../routes/index.js';

export const bootstrapExpress = (config: AppConfig): Express => {
  const app = express();

  // Basic Security & Parsing
  app.use(helmet());
  app.use(
    cors({
      origin: config.security.corsOrigin,
      credentials: true,
    }),
  );
  app.use(compression());
  app.use(express.json({ limit: '10mb' }));
  app.use(express.urlencoded({ extended: true, limit: '10mb' }));

  // Rate Limiting
  const limiter = rateLimit({
    windowMs: config.security.rateLimitWindowMs,
    max: config.security.rateLimitMaxRequests,
    standardHeaders: true,
    legacyHeaders: false,
    message: {
      success: false,
      message: 'Too many requests from this IP, please try again later.',
      data: null,
      errors: null,
      timestamp: new Date().toISOString(),
      traceId: 'rate-limit-exceeded',
    },
  });
  app.use(limiter);

  // Custom Infrastructure Middlewares
  app.use(requestIdMiddleware);
  app.use(requestLoggerMiddleware);
  app.use(responseFormatterMiddleware);

  // Swagger Documentation Endpoint
  const swaggerSpec = getSwaggerConfig(config.env);
  app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

  // Mount API Routers
  app.use(config.env.API_PREFIX, appRouter);

  // Error & Not Found Handling
  app.use(notFoundMiddleware);
  app.use(globalErrorHandlerMiddleware);

  return app;
};
