export interface OtpSendResult {
  success: boolean;
  messageId?: string;
  provider: string;
  error?: string;
}

export interface IOtpProvider {
  readonly providerName: string;
  sendOtp(phone: string, otpCode: string): Promise<OtpSendResult>;
}
