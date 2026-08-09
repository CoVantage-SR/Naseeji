import { EnvConfig } from './env.config.js';

export interface MailConfig {
  host: string;
  port: number;
  secure: boolean;
  user?: string;
  pass?: string;
  from: string;
}

export const getMailConfig = (env: EnvConfig): MailConfig => ({
  host: env.SMTP_HOST,
  port: env.SMTP_PORT,
  secure: env.SMTP_SECURE,
  user: env.SMTP_USER,
  pass: env.SMTP_PASS,
  from: env.MAIL_FROM,
});
