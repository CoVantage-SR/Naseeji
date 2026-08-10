import { z } from 'zod';

export const createProductSchema = z.object({
  body: z.object({
    categoryId: z.string().min(1, 'Category ID is required'),
    subcategoryId: z.string().optional(),
    brandId: z.string().optional(),
    sku: z.string().min(2, 'SKU must be at least 2 characters long'),
    name: z.string().min(3, 'Product name must be at least 3 characters long'),
    shortDescription: z.string().optional(),
    description: z.string().optional(),

    productType: z
      .enum(['physical', 'made_to_order', 'custom', 'service'])
      .default('physical'),
    price: z.number().min(0, 'Price must be greater than or equal to 0'),
    compareAtPrice: z.number().min(0).optional(),
    currency: z.string().default('EGP'),
    minimumOrderQuantity: z.number().int().min(1).default(1),
    stockQuantity: z.number().int().min(0).default(0),
    unit: z.string().default('piece'),
    leadTimeDays: z.number().int().min(0).default(1),

    visibility: z.enum(['public', 'private', 'hidden']).default('public'),
    isNegotiable: z.boolean().default(true),
    allowRFQ: z.boolean().default(true),

    originCountry: z.string().default('Egypt'),
    originCity: z.string().optional(),
    specifications: z
      .array(
        z.object({
          key: z.string().min(1),
          value: z.string().min(1),
        }),
      )
      .optional()
      .default([]),
    attributes: z.record(z.any()).optional().default({}),

    metaTitle: z.string().optional(),
    metaDescription: z.string().optional(),
    keywords: z.array(z.string()).optional().default([]),
  }),
});

export const updateProductSchema = z.object({
  params: z.object({
    id: z.string().min(1, 'Product ID is required'),
  }),
  body: z.object({
    categoryId: z.string().optional(),
    subcategoryId: z.string().optional(),
    brandId: z.string().optional(),
    sku: z.string().min(2).optional(),
    name: z.string().min(3).optional(),
    shortDescription: z.string().optional(),
    description: z.string().optional(),

    productType: z.enum(['physical', 'made_to_order', 'custom', 'service']).optional(),
    price: z.number().min(0).optional(),
    compareAtPrice: z.number().min(0).optional(),
    currency: z.string().optional(),
    minimumOrderQuantity: z.number().int().min(1).optional(),
    stockQuantity: z.number().int().min(0).optional(),
    unit: z.string().optional(),
    leadTimeDays: z.number().int().min(0).optional(),

    visibility: z.enum(['public', 'private', 'hidden']).optional(),
    status: z
      .enum(['draft', 'pending_review', 'active', 'inactive', 'out_of_stock'])
      .optional(),
    isNegotiable: z.boolean().optional(),
    allowRFQ: z.boolean().optional(),

    originCountry: z.string().optional(),
    originCity: z.string().optional(),
    specifications: z
      .array(
        z.object({
          key: z.string().min(1),
          value: z.string().min(1),
        }),
      )
      .optional(),
    attributes: z.record(z.any()).optional(),

    metaTitle: z.string().optional(),
    metaDescription: z.string().optional(),
    keywords: z.array(z.string()).optional(),
  }),
});

export const adminUpdateProductStatusSchema = z.object({
  params: z.object({
    id: z.string().min(1, 'Product ID is required'),
  }),
  body: z.object({
    status: z.enum([
      'draft',
      'pending_review',
      'active',
      'inactive',
      'rejected',
      'archived',
      'out_of_stock',
    ]),
    notes: z.string().optional(),
  }),
});

export type CreateProductDto = z.infer<typeof createProductSchema>['body'];
export type UpdateProductDto = z.infer<typeof updateProductSchema>['body'];
export type AdminUpdateProductStatusDto = z.infer<
  typeof adminUpdateProductStatusSchema
>['body'];
