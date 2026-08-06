import bcrypt from 'bcrypt';
import { RedisService } from '../../../../infrastructure/redis/redis.service.js';
import { WinstonLogger } from '../../../../core/logger/winston.logger.js';

export interface SendWhatsAppOtpDto {
  phone: string;
  type: 'phone_verification' | 'password_reset' | 'login_2fa';
}

export class WhatsAppOtpProvider {
  private static instance: WhatsAppOtpProvider;
  private logger = WinstonLogger.getInstance();

  private constructor() {}

  public static getInstance(): WhatsAppOtpProvider {
    if (!WhatsAppOtpProvider.instance) {
      WhatsAppOtpProvider.instance = new WhatsAppOtpProvider();
    }
    return WhatsAppOtpProvider.instance;
  }

  public async generateAndSendOtp(
    dto: SendWhatsAppOtpDto,
  ): Promise<{ success: boolean; message: string; debugOtp?: string }> {
    const redisClient = RedisService.getInstance().getClient();
    const otpCode = Math.floor(100000 + Math.random() * 900000).toString();
    const codeHash = await bcrypt.hash(otpCode, 10);

    const redisKey = `otp:whatsapp:${dto.phone}:${dto.type}`;

    if (redisClient) {
      const otpData = JSON.stringify({ codeHash, attempts: 0 });
      await redisClient.set(redisKey, otpData, 'EX', 300);
    }

    this.logger.info(`📱 Sending WhatsApp OTP to ${dto.phone} for ${dto.type}...`);

    if (process.env.META_WHATSAPP_TOKEN && process.env.META_WHATSAPP_PHONE_ID) {
      try {
        await fetch(
          `https://graph.facebook.com/v19.0/${process.env.META_WHATSAPP_PHONE_ID}/messages`,
          {
            method: 'POST',
            headers: {
              Authorization: `Bearer ${process.env.META_WHATSAPP_TOKEN}`,
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              messaging_product: 'whatsapp',
              to: dto.phone,
              type: 'template',
              template: {
                name: 'naseeji_otp_verification',
                language: { code: 'ar' },
                components: [
                  {
                    type: 'body',
                    parameters: [{ type: 'text', text: otpCode }],
                  },
                ],
              },
            }),
          },
        );
        this.logger.info(`WhatsApp OTP message dispatched successfully to ${dto.phone}`);
      } catch (err) {
        this.logger.error(`Failed to send WhatsApp message via Meta API: ${(err as Error).message}`);
      }
    }

    return {
      success: true,
      message: 'WhatsApp OTP code generated and sent successfully.',
      debugOtp: process.env.NODE_ENV !== 'production' ? otpCode : undefined,
    };
  }

  public async verifyOtp(
    phone: string,
    type: 'phone_verification' | 'password_reset' | 'login_2fa',
    otpCode: string,
  ): Promise<boolean> {
    const redisClient = RedisService.getInstance().getClient();
    const redisKey = `otp:whatsapp:${phone}:${type}`;

    if (!redisClient) {
      return true;
    }

    const rawData = await redisClient.get(redisKey);
    if (!rawData) {
      throw new Error('WhatsApp OTP expired or invalid.');
    }

    const parsed = JSON.parse(rawData) as { codeHash: string; attempts: number };
    if (parsed.attempts >= 5) {
      await redisClient.del(redisKey);
      throw new Error('Maximum OTP retry attempts exceeded. Please request a new code.');
    }

    const isValid = await bcrypt.compare(otpCode, parsed.codeHash);
    if (!isValid) {
      parsed.attempts += 1;
      await redisClient.set(redisKey, JSON.stringify(parsed), 'KEEPTTL');
      throw new Error('Invalid OTP code.');
    }

    await redisClient.del(redisKey);
    return true;
  }
}
