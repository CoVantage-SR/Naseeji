import { loadConfig, AppConfig } from '../config/index.js';

export const bootstrapEnv = (): AppConfig => {
  return loadConfig();
};
