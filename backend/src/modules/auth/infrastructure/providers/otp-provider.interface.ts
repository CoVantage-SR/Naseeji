export interface SendOtpDto {
  phone: string;
  type: 'phone_verification' | 'password_reset' | 'login_2fa';
}

export interface IOtpProvider {
  generateAndSendOtp(
    dto: SendOtpDto,
  ): Promise<{ success: boolean; message: string; debugOtp?: string }>;

  verifyOtp(
    phone: string,
    type: 'phone_verification' | 'password_reset' | 'login_2fa',
    otpCode: string,
  ): Promise<boolean>;
}
