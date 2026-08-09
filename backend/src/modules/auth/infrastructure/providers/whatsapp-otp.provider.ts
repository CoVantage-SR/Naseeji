import bcrypt from 'bcrypt';
import { IOtpProvider, SendOtpDto } from './otp-provider.interface.js';
import { OtpRepository } from '../repositories/otp.repository.js';
import { WinstonLogger } from '../../../../core/logger/winston.logger.js';

/**
 * WhatsAppOtpProvider — dispatches OTP codes via WhatsApp (Meta Business API).
 * In development/test environments it operates in mock mode: OTP is logged and returned.
 * Resend cooldown and attempt limits are enforced via OtpRepository.
 *
 * Supported env vars:
 *  - WHATSAPP_API_TOKEN       (new, preferred)
 *  - META_WHATSAPP_TOKEN      (legacy alias)
 *  - WHATSAPP_PHONE_NUMBER_ID (new, preferred)
 *  - META_WHATSAPP_PHONE_ID   (legacy alias)
 *  - WHATSAPP_API_URL         (default: https://graph.facebook.com/v19.0)
 */
export class WhatsAppOtpProvider implements IOtpProvider {
  private static instance: WhatsAppOtpProvider;
  private readonly otpRepo: OtpRepository;

  private constructor() {
    this.otpRepo = new OtpRepository();
  }

  private get logger(): WinstonLogger {
    return WinstonLogger.getInstance();
  }

  private get apiToken(): string | undefined {
    return process.env.WHATSAPP_API_TOKEN || process.env.META_WHATSAPP_TOKEN;
  }

  private get phoneNumberId(): string | undefined {
    return process.env.WHATSAPP_PHONE_NUMBER_ID || process.env.META_WHATSAPP_PHONE_ID;
  }

  private get apiBaseUrl(): string {
    return process.env.WHATSAPP_API_URL || 'https://graph.facebook.com/v19.0';
  }

  private get isProduction(): boolean {
    return process.env.NODE_ENV === 'production';
  }

  public static getInstance(): WhatsAppOtpProvider {
    if (!WhatsAppOtpProvider.instance) {
      WhatsAppOtpProvider.instance = new WhatsAppOtpProvider();
    }
    return WhatsAppOtpProvider.instance;
  }

  public async generateAndSendOtp(
    dto: SendOtpDto,
  ): Promise<{ success: boolean; message: string; debugOtp?: string }> {
    // OtpRepository.create() enforces cooldown internally — throws if active
    const { code: otpCode } = await this.otpRepo.generateOtp(dto.phone, dto.type);

    this.logger.info(`📱 WhatsApp OTP triggered for ${dto.phone} (type: ${dto.type})`);

    // Dispatch via Meta API when credentials are configured
    if (this.apiToken && this.phoneNumberId) {
      try {
        const response = await fetch(`${this.apiBaseUrl}/${this.phoneNumberId}/messages`, {
          method: 'POST',
          headers: {
            Authorization: `Bearer ${this.apiToken}`,
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
        });

        if (!response.ok) {
          const errorBody = await response.text();
          this.logger.error(`WhatsApp API error: ${response.status} — ${errorBody}`);
        } else {
          this.logger.info(`✅ WhatsApp OTP dispatched to ${dto.phone}`);
        }
      } catch (err) {
        this.logger.error(`WhatsApp API fetch failed: ${(err as Error).message}`);
      }
    } else {
      this.logger.warn(`⚠️  WhatsApp API credentials not configured. Running in mock/dev mode.`);
    }

    return {
      success: true,
      message: 'OTP code has been sent via WhatsApp.',
      // Expose code only in non-production environments for easier development/testing
      debugOtp: !this.isProduction ? otpCode : undefined,
    };
  }

  public async verifyOtp(
    phone: string,
    type: 'phone_verification' | 'password_reset' | 'login_2fa',
    otpCode: string,
  ): Promise<boolean> {
    const validOtp = await this.otpRepo.findValidOtp(phone, type);
    if (!validOtp) {
      throw new Error('WhatsApp OTP expired or not found. Please request a new code.');
    }

    const isValid = await bcrypt.compare(otpCode, validOtp.codeHash);
    if (!isValid) {
      await this.otpRepo.incrementAttempts(validOtp._id);
      throw new Error('Invalid OTP code.');
    }

    await this.otpRepo.markAsUsed(validOtp._id);
    return true;
  }
}
