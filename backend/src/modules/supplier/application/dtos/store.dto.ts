import { z } from 'zod';

export const createStoreSchema = z.object({
  body: z
    .object({
      name: z.string().min(2).max(100),
      description: z.string().max(2000).optional(),
      logo: z.string().url().or(z.string().min(1)).optional(),
      coverImage: z.string().url().or(z.string().min(1)).optional(),
      isPublic: z.boolean().optional().default(true),
    })
    .strict(),
});

export type CreateStoreDto = z.infer<typeof createStoreSchema>['body'];

export const updateStoreSchema = z.object({
  body: z
    .object({
      name: z.string().min(2).max(100).optional(),
      description: z.string().max(2000).optional(),
      logo: z.string().url().or(z.string().min(1)).optional(),
      coverImage: z.string().url().or(z.string().min(1)).optional(),
      isPublic: z.boolean().optional(),
    })
    .strict(),
});

export type UpdateStoreDto = z.infer<typeof updateStoreSchema>['body'];

export interface PublicStoreDto {
  id: string;
  supplierId: string;
  name: string;
  slug: string;
  description?: string;
  logo?: string;
  coverImage?: string;
  status: 'draft' | 'active' | 'suspended' | 'closed';
  isPublic: boolean;
  supplier?: {
    companyName: string;
    supplierCategory: string;
    isVerified: boolean;
    rating: number;
    ratingCount: number;
  };
  createdAt?: string;
  updatedAt?: string;
}
