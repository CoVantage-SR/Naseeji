import { z } from 'zod';

export const addProductMediaSchema = z.object({
  body: z.object({
    productId: z.string().min(1, 'Product ID is required'),
    type: z.enum(['image', 'video', 'document']),
    url: z.string().url('Invalid file URL'),
    thumbnailUrl: z.string().url('Invalid thumbnail URL').optional().or(z.literal('')),
    fileSize: z.number().int().min(1, 'File size must be greater than 0'),
    mimeType: z.string().min(1, 'MIME type is required'),
    duration: z.number().min(0).optional(),
    sortOrder: z.number().int().optional().default(0),
    isPrimary: z.boolean().optional().default(false),
  }),
});

export const reorderProductMediaSchema = z.object({
  body: z.object({
    productId: z.string().min(1, 'Product ID is required'),
    items: z
      .array(
        z.object({
          id: z.string().min(1),
          sortOrder: z.number().int(),
        }),
      )
      .min(1, 'At least one media item must be specified'),
  }),
});

export type AddProductMediaDto = z.infer<typeof addProductMediaSchema>['body'];
export type ReorderProductMediaDto = z.infer<typeof reorderProductMediaSchema>['body'];
