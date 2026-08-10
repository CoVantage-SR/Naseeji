import { z } from 'zod';

export const createCategorySchema = z.object({
  body: z.object({
    name: z.string().min(2, 'Category name must be at least 2 characters long'),
    description: z.string().optional(),
    image: z.string().url('Invalid image URL').optional().or(z.literal('')),
    parentId: z.string().nullable().optional(),
    sortOrder: z.number().int().optional(),
    isFeatured: z.boolean().optional(),
    status: z.enum(['active', 'inactive']).optional(),
  }),
});

export const updateCategorySchema = z.object({
  params: z.object({
    id: z.string().min(1, 'Category ID is required'),
  }),
  body: z.object({
    name: z.string().min(2, 'Category name must be at least 2 characters long').optional(),
    description: z.string().optional(),
    image: z.string().url('Invalid image URL').optional().or(z.literal('')),
    parentId: z.string().nullable().optional(),
    sortOrder: z.number().int().optional(),
    isFeatured: z.boolean().optional(),
    status: z.enum(['active', 'inactive', 'archived']).optional(),
  }),
});

export type CreateCategoryDto = z.infer<typeof createCategorySchema>['body'];
export type UpdateCategoryDto = z.infer<typeof updateCategorySchema>['body'];
