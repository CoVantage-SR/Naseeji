import { WinstonLogger } from '../../../../core/logger/winston.logger.js';

export interface GooglePayload {
  sub: string;
  email: string;
  email_verified: boolean;
  name?: string;
  picture?: string;
}

export class GoogleOAuthService {
  private logger = WinstonLogger.getInstance();

  public async verifyIdToken(idToken: string): Promise<GooglePayload> {
    try {
      const response = await fetch(
        `https://oauth2.googleapis.com/tokeninfo?id_token=${encodeURIComponent(idToken)}`,
      );

      if (!response.ok) {
        throw new Error('Google OAuth token verification failed');
      }

      const data = (await response.json()) as GooglePayload;
      if (!data.email) {
        throw new Error('Google payload missing email');
      }

      return data;
    } catch (error) {
      this.logger.error(`Google Token Validation Error: ${(error as Error).message}`);
      throw new Error('Invalid or expired Google OAuth ID Token');
    }
  }
}
