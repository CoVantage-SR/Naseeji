import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';
import { BrandStatus } from '../../domain/catalog.types.js';

export interface IBrandDocument {
  _id: string;
  name: string;
  slug: string;
  description?: string;
  logo?: string;
  status: BrandStatus;
  createdAt?: Date;
  updatedAt?: Date;
}

const brandSchema = new Schema<IBrandDocument>(
  {
    _id: { type: String, required: true },
    name: { type: String, required: true, trim: true, index: true },
    slug: { type: String, required: true, unique: true, index: true, trim: true },
    description: { type: String },
    logo: { type: String },
    status: {
      type: String,
      enum: ['active', 'inactive', 'archived'],
      default: 'active',
      index: true,
    },
  },
  baseSchemaOptions,
);

brandSchema.index({ status: 1, name: 1 });

export const BrandModel = model<IBrandDocument>('Brand', brandSchema, 'brands');
