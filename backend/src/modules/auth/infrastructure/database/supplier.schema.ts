import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export type SupplierBusinessType =
  'manufacturer' | 'wholesaler' | 'distributor' | 'importer' | 'agent';
export type SupplierVerificationLevel = 'none' | 'basic' | 'verified' | 'premium';

export interface ISupplierDocument {
  _id: string;
  userId: string;
  companyName: string;
  slug: string;
  description?: string;
  supplierCategory: string;
  businessType?: SupplierBusinessType;
  logo?: string;
  coverImage?: string;
  phone: string;
  email?: string;
  commercialRegistration: string;
  taxNumber: string;
  country: string;
  governorate: string;
  city?: string;
  address: string;
  website?: string;
  verificationStatus: 'pending' | 'verified' | 'rejected' | 'need_more_documents';
  verificationLevel: SupplierVerificationLevel;
  isVerified: boolean;
  verificationNotes?: string;
  subscriptionStatus: 'active' | 'inactive' | 'suspended' | 'trial';
  rating: number;
  ratingCount: number;
  totalProducts: number;
  totalOrders: number;
  responseRate: number;
  responseTime: number;
  isActive: boolean;
  createdAt?: Date;
  updatedAt?: Date;
}

const supplierSchema = new Schema<ISupplierDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, ref: 'User', index: true },
    companyName: { type: String, required: true, index: true },
    slug: { type: String, required: true, unique: true, index: true },
    description: { type: String },
    supplierCategory: { type: String, required: true, index: true },
    businessType: {
      type: String,
      enum: ['manufacturer', 'wholesaler', 'distributor', 'importer', 'agent'],
      default: 'manufacturer',
      index: true,
    },
    logo: { type: String },
    coverImage: { type: String },
    phone: { type: String, required: true },
    email: { type: String },
    commercialRegistration: { type: String, required: true, unique: true, index: true },
    taxNumber: { type: String, required: true, unique: true, index: true },
    country: { type: String, required: true, default: 'Egypt' },
    governorate: { type: String, required: true, index: true },
    city: { type: String, index: true },
    address: { type: String, required: true },
    website: { type: String },
    verificationStatus: {
      type: String,
      enum: ['pending', 'verified', 'rejected', 'need_more_documents'],
      default: 'pending',
      index: true,
    },
    verificationLevel: {
      type: String,
      enum: ['none', 'basic', 'verified', 'premium'],
      default: 'none',
      index: true,
    },
    isVerified: { type: Boolean, default: false, index: true },
    verificationNotes: { type: String },
    subscriptionStatus: {
      type: String,
      enum: ['active', 'inactive', 'suspended', 'trial'],
      default: 'inactive',
      index: true,
    },
    rating: { type: Number, default: 0, index: true },
    ratingCount: { type: Number, default: 0 },
    totalProducts: { type: Number, default: 0 },
    totalOrders: { type: Number, default: 0 },
    responseRate: { type: Number, default: 100 },
    responseTime: { type: Number, default: 24 },
    isActive: { type: Boolean, default: true, index: true },
  },
  baseSchemaOptions,
);

supplierSchema.index({
  supplierCategory: 1,
  governorate: 1,
  city: 1,
  isVerified: 1,
  isActive: 1,
  rating: -1,
});

export const SupplierModel = model<ISupplierDocument>('Supplier', supplierSchema, 'suppliers');
