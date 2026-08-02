import mongoose, { ClientSession } from 'mongoose';
import { WinstonLogger } from '../../core/logger/winston.logger.js';

export class MongoTransactionManager {
  public static async runInTransaction<T>(
    work: (session: ClientSession | null) => Promise<T>,
  ): Promise<T> {
    const logger = WinstonLogger.getInstance();
    let session: ClientSession | null = null;

    try {
      // Attempt transaction (Requires MongoDB Replica Set or Sharded Cluster)
      session = await mongoose.startSession();
      session.startTransaction();

      const result = await work(session);

      await session.commitTransaction();
      return result;
    } catch (error) {
      if (session && session.inTransaction()) {
        await session.abortTransaction();
      }
      logger.warn('Transaction aborted or unsupported by standalone MongoDB. Fallback executed.', {
        error: (error as Error).message,
      });

      // Fallback execution without session for standalone dev MongoDB instances
      if (
        (error as Error).message.includes('Transaction numbers are only allowed on a replica set')
      ) {
        return await work(null);
      }

      throw error;
    } finally {
      if (session) {
        session.endSession();
      }
    }
  }
}
