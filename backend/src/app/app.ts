import { Express } from 'express';
import { MasterBootstrapper, BootstrapResult } from '../bootstrap/index.js';

export const createApplication = async (): Promise<BootstrapResult> => {
  return MasterBootstrapper.bootstrap();
};

export { Express };
