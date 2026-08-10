import { z } from 'zod';

export const updateSupplierProfileSchema = z.object({
  body: z
    .object({
      companyName: z.string().min(2).max(100).optional(),
      description: z.string().max(2000).optional(),
      supplierCategory: z.string().min(2).optional(),
      businessType: z
        .enum(['manufacturer', 'wholesaler', 'distributor', 'importer', 'agent'])
        .optional(),
      logo: z.string().url().or(z.string().min(1)).optional(),
      coverImage: z.string().url().or(z.string().min(1)).optional(),
      phone: z.string().min(8).optional(),
      email: z.string().email().optional(),
      governorate: z.string().min(2).optional(),
      city: z.string().min(2).optional(),
      address: z.string().min(5).optional(),
      website: z.string().url().or(z.string().min(1)).optional(),
    })
    .strict(),
});

export type UpdateSupplierProfileDto = z.infer<typeof updateSupplierProfileSchema>['body'];

export const submitVerificationSchema = z.object({
  body: z
    .object({
      commercialRegistration: z.string().min(3),
      taxNumber: z.string().min(3),
      documents: z.array(
        z.object({
          documentType: z.string().min(2),
          url: z.string().min(1),
        }),
      ),
      notes: z.string().max(500).optional(),
    })
    .strict(),
});

export type SubmitVerificationDto = z.infer<typeof submitVerificationSchema>['body'];

export const adminUpdateVerificationSchema = z.object({
  body: z
    .object({
      status: z.enum(['pending', 'verified', 'rejected', 'need_more_documents']),
      notes: z.string().max(500).optional(),
    })
    .strict(),
});

export type AdminUpdateVerificationDto = z.infer<typeof adminUpdateVerificationSchema>['body'];

export const adminSupplierStatusSchema = z.object({
  body: z
    .object({
      isActive: z.boolean(),
      reason: z.string().max(500).optional(),
    })
    .strict(),
});

export type AdminSupplierStatusDto = z.infer<typeof adminSupplierStatusSchema>['body'];

export interface PublicSupplierDto {
  id: string;
  companyName: string;
  slug: string;
  description?: string;
  supplierCategory: string;
  businessType?: string;
  logo?: string;
  coverImage?: string;
  governorate: string;
  city?: string;
  website?: string;
  isVerified: boolean;
  verificationLevel: string;
  rating: number;
  ratingCount: number;
  totalProducts: number;
  totalOrders: number;
  responseRate: number;
  responseTime: number;
  isActive: boolean;
  createdAt?: string;
}

export interface PrivateSupplierDto extends PublicSupplierDto {
  userId: string;
  phone: string;
  email?: string;
  address: string;
  commercialRegistration: string;
  taxNumber: string;
  verificationStatus: string;
  verificationNotes?: string;
  subscriptionStatus: string;
}
