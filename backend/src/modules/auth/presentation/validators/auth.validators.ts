import { z } from 'zod';

const phoneRegex = /^\+?[1-9]\d{1,14}$/;
const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

export const registerFactorySchema = z.object({
  body: z.object({
    phone: z.string().regex(phoneRegex, 'Invalid phone number format'),
    email: z.string().email('Invalid email address'),
    password: z.string().regex(
      passwordRegex,
      'Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character',
    ),
    companyName: z.string().min(2, 'Company name must be at least 2 characters'),
    factoryType: z.string().min(2, 'Factory type is required'),
    governorate: z.string().min(2, 'Governorate is required'),
    city: z.string().min(2, 'City is required'),
    address: z.string().min(5, 'Address must be at least 5 characters'),
    commercialRegistration: z.string().min(5, 'Commercial registration must be at least 5 digits'),
    taxNumber: z.string().min(9, 'Tax number must be at least 9 digits'),
    logoUrl: z.string().url().optional(),
  }),
});

export const registerSupplierSchema = z.object({
  body: z.object({
    phone: z.string().regex(phoneRegex, 'Invalid phone number format'),
    email: z.string().email('Invalid email address'),
    password: z.string().regex(
      passwordRegex,
      'Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character',
    ),
    companyName: z.string().min(2, 'Company name must be at least 2 characters'),
    supplierCategory: z.string().min(2, 'Supplier category is required'),
    commercialRegistration: z.string().min(5, 'Commercial registration must be at least 5 digits'),
    taxNumber: z.string().min(9, 'Tax number must be at least 9 digits'),
    country: z.string().default('Egypt'),
    governorate: z.string().min(2, 'Governorate is required'),
    address: z.string().min(5, 'Address must be at least 5 characters'),
  }),
});

export const loginSchema = z.object({
  body: z.object({
    identifier: z.string().min(3, 'Phone or email is required'),
    password: z.string().min(1, 'Password is required'),
    rememberMe: z.boolean().optional(),
    deviceId: z.string().optional(),
  }),
});

export const refreshTokenSchema = z.object({
  body: z.object({
    refreshToken: z.string().min(1, 'Refresh token is required'),
  }),
});

export const forgotPasswordSchema = z.object({
  body: z.object({
    target: z.string().min(3, 'Email or phone number is required'),
  }),
});

export const resetPasswordSchema = z.object({
  body: z.object({
    target: z.string().min(3, 'Email or phone number is required'),
    otpCode: z.string().length(6, 'OTP must be 6 digits'),
    newPassword: z.string().regex(
      passwordRegex,
      'Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character',
    ),
  }),
});

export const changePasswordSchema = z.object({
  body: z.object({
    oldPassword: z.string().min(1, 'Current password is required'),
    newPassword: z.string().regex(
      passwordRegex,
      'Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character',
    ),
  }),
});

export const verifyOtpSchema = z.object({
  body: z.object({
    target: z.string().min(3, 'Target email/phone is required'),
    otpCode: z.string().length(6, 'OTP must be 6 digits'),
    type: z.enum(['phone_verification', 'email_verification', 'password_reset']),
  }),
});

export const updateVerificationStatusSchema = z.object({
  body: z.object({
    status: z.enum(['pending', 'verified', 'rejected', 'need_more_documents']),
    notes: z.string().optional(),
  }),
});
