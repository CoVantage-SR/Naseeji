import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';
import { MediaType } from '../../domain/catalog.types.js';

export interface IProductMediaDocument {
  _id: string;
  productId: string;
  type: MediaType;
  url: string;
  thumbnailUrl?: string;
  fileSize: number;
  mimeType: string;
  duration?: number;
  sortOrder: number;
  isPrimary: boolean;
  createdAt?: Date;
  updatedAt?: Date;
}

const productMediaSchema = new Schema<IProductMediaDocument>(
  {
    _id: { type: String, required: true },
    productId: { type: String, required: true, ref: 'Product', index: true },
    type: {
      type: String,
      enum: ['image', 'video', 'document'],
      required: true,
      index: true,
    },
    url: { type: String, required: true },
    thumbnailUrl: { type: String },
    fileSize: { type: Number, required: true },
    mimeType: { type: String, required: true },
    duration: { type: Number },
    sortOrder: { type: Number, default: 0 },
    isPrimary: { type: Boolean, default: false, index: true },
  },
  baseSchemaOptions,
);

productMediaSchema.index({ productId: 1, sortOrder: 1 });
productMediaSchema.index({ productId: 1, isPrimary: 1 });

export const ProductMediaModel = model<IProductMediaDocument>(
  'ProductMedia',
  productMediaSchema,
  'product_media',
);
