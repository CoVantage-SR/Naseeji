import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';
import { CategoryStatus } from '../../domain/catalog.types.js';

export interface ICategoryDocument {
  _id: string;
  name: string;
  slug: string;
  description?: string;
  image?: string;
  parentId?: string | null;
  level: number;
  status: CategoryStatus;
  sortOrder: number;
  isFeatured: boolean;
  productCount: number;
  createdAt?: Date;
  updatedAt?: Date;
}

const categorySchema = new Schema<ICategoryDocument>(
  {
    _id: { type: String, required: true },
    name: { type: String, required: true, trim: true, index: true },
    slug: { type: String, required: true, unique: true, index: true, trim: true },
    description: { type: String },
    image: { type: String },
    parentId: { type: String, default: null, index: true },
    level: { type: Number, default: 0, index: true },
    status: {
      type: String,
      enum: ['active', 'inactive', 'archived'],
      default: 'active',
      index: true,
    },
    sortOrder: { type: Number, default: 0, index: true },
    isFeatured: { type: Boolean, default: false, index: true },
    productCount: { type: Number, default: 0 },
  },
  baseSchemaOptions,
);

categorySchema.index({ parentId: 1, status: 1 });
categorySchema.index({ status: 1, sortOrder: 1 });
categorySchema.index({ isFeatured: 1, status: 1 });

export const CategoryModel = model<ICategoryDocument>('Category', categorySchema, 'categories');
