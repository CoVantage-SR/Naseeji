import { z } from 'zod';

export const createRoleSchema = z.object({
  code: z.string().min(2).max(50).toUpperCase(),
  name: z.string().min(2).max(100),
  description: z.string().max(255).default(''),
  permissionCodes: z.array(z.string()).default([]),
});

export const updateRoleSchema = z.object({
  name: z.string().min(2).max(100).optional(),
  description: z.string().max(255).optional(),
  permissionCodes: z.array(z.string()).optional(),
});

export type CreateRoleDto = z.infer<typeof createRoleSchema>;
export type UpdateRoleDto = z.infer<typeof updateRoleSchema>;

export interface RoleResponseDto {
  id: string;
  code: string;
  name: string;
  description: string;
  isSystemRole: boolean;
  permissionCodes: string[];
  createdAt?: string;
  updatedAt?: string;
}

export interface PermissionResponseDto {
  id: string;
  code: string;
  name?: string;
  group: string;
  description: string;
}
