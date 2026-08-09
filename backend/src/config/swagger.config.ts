import fs from 'fs';
import path from 'path';
import { EnvConfig } from './env.config.js';

export const getSwaggerConfig = (env: EnvConfig): Record<string, unknown> => {
  const swaggerJsonPath = path.resolve(process.cwd(), 'src/docs/swagger.json');
  try {
    const rawData = fs.readFileSync(swaggerJsonPath, 'utf8');
    const spec = JSON.parse(rawData);
    spec.servers = [
      {
        url: `http://localhost:${env.PORT}${env.API_PREFIX}`,
        description: 'Development Server',
      },
    ];
    return spec;
  } catch (error) {
    return {
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
    };
  }
};
