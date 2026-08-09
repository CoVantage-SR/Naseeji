import { z } from 'zod';

export const createEmployeeSchema = z.object({
  fullName: z.string().min(2).max(100),
  email: z.string().email(),
  phone: z.string().min(8).max(20),
  password: z.string().min(8).max(100).optional(),
  position: z.string().max(100).optional(),
  role: z.string().default('employee'),
  permissions: z.array(z.string()).default([]),
});

export const updateEmployeeSchema = z.object({
  fullName: z.string().min(2).max(100).optional(),
  position: z.string().max(100).optional(),
  role: z.string().optional(),
  permissions: z.array(z.string()).optional(),
});

export const changeEmployeeStatusSchema = z.object({
  status: z.enum(['active', 'suspended', 'deactivated']),
  reason: z.string().optional(),
});

export type CreateEmployeeDto = z.infer<typeof createEmployeeSchema>;
export type UpdateEmployeeDto = z.infer<typeof updateEmployeeSchema>;
export type ChangeEmployeeStatusDto = z.infer<typeof changeEmployeeStatusSchema>;

export interface EmployeeResponseDto {
  id: string;
  userId: string;
  organizationId: string;
  organizationType: 'factory' | 'supplier';
  fullName: string;
  email: string;
  phone: string;
  position?: string;
  role: string;
  permissions: string[];
  status: string;
  createdAt?: string;
  updatedAt?: string;
}
