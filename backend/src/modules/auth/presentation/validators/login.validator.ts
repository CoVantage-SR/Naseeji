import { z } from 'zod';

export const loginSchema = z.object({
  body: z.object({
    phone: z.string().min(8, 'Phone number is required'),
    password: z.string().optional(),
    platform: z.string().min(1, 'Platform is required'),
    deviceName: z.string().min(1, 'Device name is required'),
    osVersion: z.string().min(1, 'OS version is required'),
    appName: z.string().min(1, 'App name is required'),
    appVersion: z.string().min(1, 'App version is required'),
    pushToken: z.string().optional(),
    isRememberMe: z.boolean().optional(),
  }),
});

export const verifyDeviceLoginSchema = z.object({
  body: z.object({
    phone: z.string().min(8, 'Phone number is required'),
    otpCode: z.string().length(6, 'OTP code must be 6 digits'),
    platform: z.string().min(1, 'Platform is required'),
    deviceName: z.string().min(1, 'Device name is required'),
    osVersion: z.string().min(1, 'OS version is required'),
    appName: z.string().min(1, 'App name is required'),
    appVersion: z.string().min(1, 'App version is required'),
    pushToken: z.string().optional(),
    isRememberMe: z.boolean().optional(),
  }),
});
