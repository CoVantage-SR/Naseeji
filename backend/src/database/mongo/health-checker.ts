import mongoose from 'mongoose';

export interface DatabaseHealthStatus {
  status: 'up' | 'down';
  dbName?: string;
  readyState: number;
}

export class MongoHealthChecker {
  public static async check(): Promise<DatabaseHealthStatus> {
    const readyState = mongoose.connection.readyState;
    const isUp = readyState === 1;

    return {
      status: isUp ? 'up' : 'down',
      dbName: mongoose.connection.name,
      readyState,
    };
  }
}
