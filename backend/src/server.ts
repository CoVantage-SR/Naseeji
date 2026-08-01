import { MasterBootstrapper } from './bootstrap/index.js';
import { setupGracefulShutdown } from './bootstrap/shutdown.bootstrap.js';

async function startServer(): Promise<void> {
  try {
    const { app, config, logger } = await MasterBootstrapper.bootstrap();
    const port = config.env.PORT;

    const server = app.listen(port, () => {
      logger.info(`🚀 NASEEJI Enterprise Server running on port ${port} [${config.env.NODE_ENV}]`);
      logger.info(`📚 OpenAPI Documentation available at http://localhost:${port}/api/docs`);
      logger.info(`❤️ Health Check available at http://localhost:${port}${config.env.API_PREFIX}/health`);
    });

    setupGracefulShutdown(server);
  } catch (error) {
    console.error('Fatal Server Startup Error:', error);
    process.exit(1);
  }
}

void startServer();
