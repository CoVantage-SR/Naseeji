/* eslint-disable @typescript-eslint/no-namespace, @typescript-eslint/no-unused-vars */
import { Request } from 'express';

declare global {
  namespace Express {
    interface Request {
      traceId?: string;
      startTime?: number;
    }
  }
}
