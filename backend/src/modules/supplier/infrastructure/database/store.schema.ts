import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export type StoreStatusType = 'draft' | 'active' | 'suspended' | 'closed';

export interface IStoreDocument {
  _id: string;
  supplierId: string;
  name: string;
  slug: string;
  description?: string;
  logo?: string;
  coverImage?: string;
  status: StoreStatusType;
  isPublic: boolean;
  createdAt?: Date;
  updatedAt?: Date;
}

const storeSchema = new Schema<IStoreDocument>(
  {
    _id: { type: String, required: true },
    supplierId: { type: String, required: true, ref: 'Supplier', unique: true, index: true },
    name: { type: String, required: true, index: true },
    slug: { type: String, required: true, unique: true, index: true },
    description: { type: String },
    logo: { type: String },
    coverImage: { type: String },
    status: {
      type: String,
      enum: ['draft', 'active', 'suspended', 'closed'],
      default: 'active',
      index: true,
    },
    isPublic: { type: Boolean, default: true, index: true },
  },
  baseSchemaOptions,
);

storeSchema.index({ supplierId: 1, status: 1, isPublic: 1 });

export const StoreModel = model<IStoreDocument>('Store', storeSchema, 'stores');
