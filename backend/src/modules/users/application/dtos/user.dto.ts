import { z } from 'zod';

export const updateMeSchema = z
  .object({
    phone: z.string().min(8).max(20).optional(),
    email: z.string().email().optional(),
    companyName: z.string().min(2).max(100).optional(),
    governorate: z.string().optional(),
    city: z.string().optional(),
    address: z.string().optional(),
    country: z.string().optional(),
    logoUrl: z.string().url().optional().or(z.literal('')),
    position: z.string().max(100).optional(),
  })
  .strict();

export type UpdateMeDto = z.infer<typeof updateMeSchema>;

export interface GetMeResponseDto {
  id: string;
  phone: string;
  email: string;
  role: string;
  status: string;
  isEmailVerified: boolean;
  isPhoneVerified: boolean;
  factoryId?: string;
  supplierId?: string;
  employeeId?: string;
  walletId?: string;
  profile?: Record<string, unknown> | null;
  wallet?: {
    id: string;
    balance: number;
    pointsBalance: number;
    currency: string;
  } | null;
  permissions?: string[];
  createdAt?: string;
  updatedAt?: string;
}
