import { z } from 'zod';

export const createBrandSchema = z.object({
  body: z.object({
    name: z.string().min(2, 'Brand name must be at least 2 characters long'),
    description: z.string().optional(),
    logo: z.string().url('Invalid logo URL').optional().or(z.literal('')),
    status: z.enum(['active', 'inactive']).optional(),
  }),
});

export const updateBrandSchema = z.object({
  params: z.object({
    id: z.string().min(1, 'Brand ID is required'),
  }),
  body: z.object({
    name: z.string().min(2, 'Brand name must be at least 2 characters long').optional(),
    description: z.string().optional(),
    logo: z.string().url('Invalid logo URL').optional().or(z.literal('')),
    status: z.enum(['active', 'inactive', 'archived']).optional(),
  }),
});

export type CreateBrandDto = z.infer<typeof createBrandSchema>['body'];
export type UpdateBrandDto = z.infer<typeof updateBrandSchema>['body'];
