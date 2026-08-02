import { z } from 'zod';

export const generateOtpSchema = z.object({
  body: z.object({
    phone: z.string().min(8, 'Phone number is required'),
  }),
});

export const verifyOtpSchema = z.object({
  body: z.object({
    phone: z.string().min(8, 'Phone number is required'),
    code: z.string().length(6, 'OTP code must be 6 digits'),
  }),
});
