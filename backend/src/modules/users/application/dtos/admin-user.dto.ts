import { z } from 'zod';
import { UserRoleType, UserStatusType } from '../../../auth/infrastructure/database/user.schema.js';

export const updateUserStatusSchema = z.object({
  status: z.enum([
    'active',
    'pending',
    'deactivated',
    'deleted',
    'suspended',
    'blocked',
    'rejected',
  ]),
  reason: z.string().optional(),
});

export type UpdateUserStatusDto = z.infer<typeof updateUserStatusSchema>;

export interface ListUsersQueryDto {
  search?: string;
  role?: UserRoleType;
  status?: UserStatusType;
  page?: number;
  limit?: number;
}

export interface UserSummaryDto {
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
  createdAt?: string;
  updatedAt?: string;
}

export interface PaginatedUsersResponseDto {
  users: UserSummaryDto[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}
