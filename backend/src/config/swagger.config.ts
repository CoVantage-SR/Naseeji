import { EnvConfig } from './env.config.js';

export const getSwaggerConfig = (env: EnvConfig): Record<string, unknown> => ({
  openapi: '3.0.0',
  info: {
    title: 'NASEEJI B2B SaaS Enterprise Backend API',
    version: '1.0.0',
    description: 'Enterprise API Documentation for NASEEJI Platform',
  },
  servers: [
    {
      url: `http://localhost:${env.PORT}${env.API_PREFIX}`,
      description: 'Development Server',
    },
  ],
  paths: {},
});
