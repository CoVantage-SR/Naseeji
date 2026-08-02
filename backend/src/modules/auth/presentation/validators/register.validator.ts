import { z } from 'zod';

export const registerUserSchema = z.object({
  body: z.object({
    phone: z.string().min(8, 'Phone number is required'),
    password: z.string().min(8, 'Password must be at least 8 characters').optional(),
    email: z.string().email('Invalid email address format').optional(),
    accountType: z.enum([
      'Factory',
      'Supplier',
      'Admin',
      'SuperAdmin',
      'Sales',
      'Finance',
      'Quality',
      'Logistics',
      'Support',
    ]),
    firstName: z.string().min(2, 'First name is required'),
    lastName: z.string().min(2, 'Last name is required'),
    companyName: z.string().min(2, 'Company name is required'),
    registrationNumber: z.string().min(3, 'Registration CR / Tax ID is required'),
    platform: z.string().min(1, 'Platform is required'),
    deviceName: z.string().min(1, 'Device name is required'),
    osVersion: z.string().min(1, 'OS version is required'),
    appName: z.string().min(1, 'App name is required'),
    appVersion: z.string().min(1, 'App version is required'),
    pushToken: z.string().optional(),
  }),
});
