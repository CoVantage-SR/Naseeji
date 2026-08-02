import { z } from 'zod';

export const forgotPasswordSchema = z.object({
  body: z.object({
    phone: z.string().min(8, 'Phone number is required'),
  }),
});

export const resetPasswordSchema = z.object({
  body: z.object({
    phone: z.string().min(8, 'Phone number is required'),
    otpCode: z.string().length(6, 'OTP code must be 6 digits'),
    newPassword: z.string().min(8, 'Password must be at least 8 characters long'),
  }),
});
