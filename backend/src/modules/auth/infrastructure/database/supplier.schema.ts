import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface ISupplierDocument {
  _id: string;
  userId: string;
  companyName: string;
  supplierCategory: string;
  phone: string;
  email?: string;
  commercialRegistration: string;
  taxNumber: string;
  country: string;
  governorate: string;
  address: string;
  verificationStatus: 'pending' | 'verified' | 'rejected' | 'need_more_documents';
  verificationNotes?: string;
  subscriptionStatus: 'active' | 'inactive' | 'suspended' | 'trial';
  createdAt?: Date;
  updatedAt?: Date;
}

const supplierSchema = new Schema<ISupplierDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, ref: 'User', index: true },
    companyName: { type: String, required: true, index: true },
    supplierCategory: { type: String, required: true },
    phone: { type: String, required: true },
    email: { type: String },
    commercialRegistration: { type: String, required: true, unique: true, index: true },
    taxNumber: { type: String, required: true, unique: true, index: true },
    country: { type: String, required: true, default: 'Egypt' },
    governorate: { type: String, required: true },
    address: { type: String, required: true },
    verificationStatus: {
      type: String,
      enum: ['pending', 'verified', 'rejected', 'need_more_documents'],
      default: 'pending',
      index: true,
    },
    verificationNotes: { type: String },
    subscriptionStatus: {
      type: String,
      enum: ['active', 'inactive', 'suspended', 'trial'],
      default: 'inactive',
      index: true,
    },
  },
  baseSchemaOptions,
);

export const SupplierModel = model<ISupplierDocument>('Supplier', supplierSchema, 'suppliers');
