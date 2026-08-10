import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';
import {
  ProductType,
  ProductStatus,
  ProductVisibility,
  ProductSpecification,
} from '../../domain/catalog.types.js';

export interface IProductDocument {
  _id: string;
  supplierId: string;
  storeId: string;
  categoryId: string;
  subcategoryId?: string;
  brandId?: string;
  sku: string;
  name: string;
  slug: string;
  shortDescription?: string;
  description?: string;

  // Commercial
  productType: ProductType;
  price: number;
  compareAtPrice?: number;
  currency: string;
  minimumOrderQuantity: number;
  stockQuantity: number;
  unit: string;
  leadTimeDays: number;

  // Marketplace
  status: ProductStatus;
  visibility: ProductVisibility;
  isFeatured: boolean;
  isNegotiable: boolean;
  allowRFQ: boolean;
  rating: number;
  ratingCount: number;
  totalOrders: number;
  viewCount: number;

  // Business
  originCountry: string;
  originCity?: string;
  specifications: ProductSpecification[];
  attributes: Record<string, any>;

  // SEO
  metaTitle?: string;
  metaDescription?: string;
  keywords: string[];

  publishedAt?: Date;
  createdAt?: Date;
  updatedAt?: Date;
}

const productSpecificationSchema = new Schema<ProductSpecification>(
  {
    key: { type: String, required: true },
    value: { type: String, required: true },
  },
  { _id: false },
);

const productSchema = new Schema<IProductDocument>(
  {
    _id: { type: String, required: true },
    supplierId: { type: String, required: true, ref: 'Supplier', index: true },
    storeId: { type: String, required: true, ref: 'Store', index: true },
    categoryId: { type: String, required: true, ref: 'Category', index: true },
    subcategoryId: { type: String, ref: 'Category', index: true },
    brandId: { type: String, ref: 'Brand', index: true },
    sku: { type: String, required: true, unique: true, index: true, trim: true },
    name: { type: String, required: true, trim: true, index: true },
    slug: { type: String, required: true, unique: true, index: true, trim: true },
    shortDescription: { type: String },
    description: { type: String },

    // Commercial
    productType: {
      type: String,
      enum: ['physical', 'made_to_order', 'custom', 'service'],
      default: 'physical',
      index: true,
    },
    price: { type: Number, required: true, min: 0, index: true },
    compareAtPrice: { type: Number, min: 0 },
    currency: { type: String, default: 'EGP' },
    minimumOrderQuantity: { type: Number, default: 1, min: 1 },
    stockQuantity: { type: Number, default: 0, min: 0 },
    unit: { type: String, default: 'piece' },
    leadTimeDays: { type: Number, default: 1, min: 0 },

    // Marketplace
    status: {
      type: String,
      enum: [
        'draft',
        'pending_review',
        'active',
        'inactive',
        'rejected',
        'archived',
        'out_of_stock',
      ],
      default: 'draft',
      index: true,
    },
    visibility: {
      type: String,
      enum: ['public', 'private', 'hidden'],
      default: 'public',
      index: true,
    },
    isFeatured: { type: Boolean, default: false, index: true },
    isNegotiable: { type: Boolean, default: true },
    allowRFQ: { type: Boolean, default: true },
    rating: { type: Number, default: 0, index: true },
    ratingCount: { type: Number, default: 0 },
    totalOrders: { type: Number, default: 0 },
    viewCount: { type: Number, default: 0 },

    // Business
    originCountry: { type: String, default: 'Egypt', index: true },
    originCity: { type: String, index: true },
    specifications: { type: [productSpecificationSchema], default: [] },
    attributes: { type: Schema.Types.Mixed, default: {} },

    // SEO
    metaTitle: { type: String },
    metaDescription: { type: String },
    keywords: { type: [String], default: [] },

    publishedAt: { type: Date },
  },
  baseSchemaOptions,
);

productSchema.index({ supplierId: 1, status: 1 });
productSchema.index({ storeId: 1, status: 1 });
productSchema.index({ categoryId: 1, status: 1, visibility: 1 });
productSchema.index({ subcategoryId: 1, status: 1, visibility: 1 });
productSchema.index({ brandId: 1, status: 1 });
productSchema.index({ status: 1, visibility: 1, createdAt: -1 });
productSchema.index({ status: 1, visibility: 1, rating: -1 });
productSchema.index({ status: 1, visibility: 1, price: 1 });

productSchema.index(
  {
    name: 'text',
    sku: 'text',
    description: 'text',
    keywords: 'text',
  },
  {
    weights: {
      name: 10,
      sku: 8,
      keywords: 5,
      description: 2,
    },
    name: 'product_text_search',
  },
);

export const ProductModel = model<IProductDocument>('Product', productSchema, 'products');
