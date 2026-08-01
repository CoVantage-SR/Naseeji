import { DatabaseConfig } from '../config/database.config.js';
import { MongoConnectionManager } from '../database/mongo/connection-manager.js';
import { MongoIndexLoader } from '../database/mongo/index-loader.js';

export const bootstrapDatabase = async (config: DatabaseConfig): Promise<void> => {
  await MongoConnectionManager.connect(config);
  await MongoIndexLoader.loadIndexes();
};
