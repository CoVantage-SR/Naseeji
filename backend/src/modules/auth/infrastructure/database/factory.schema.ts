import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IFactoryDocument {
  _id: string;
  userId: string;
  companyName: string;
  factoryType: string;
  governorate: string;
  city: string;
  address: string;
  commercialRegistration: string;
  taxNumber: string;
  logoUrl?: string;
  verificationStatus: 'pending' | 'verified' | 'rejected' | 'need_more_documents';
  verificationNotes?: string;
  createdAt?: Date;
  updatedAt?: Date;
}

const factorySchema = new Schema<IFactoryDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, ref: 'User', index: true },
    companyName: { type: String, required: true, index: true },
    factoryType: { type: String, required: true },
    governorate: { type: String, required: true },
    city: { type: String, required: true },
    address: { type: String, required: true },
    commercialRegistration: { type: String, required: true, unique: true, index: true },
    taxNumber: { type: String, required: true, unique: true, index: true },
    logoUrl: { type: String },
    verificationStatus: {
      type: String,
      enum: ['pending', 'verified', 'rejected', 'need_more_documents'],
      default: 'pending',
      index: true,
    },
    verificationNotes: { type: String },
  },
  baseSchemaOptions,
);

export const FactoryModel = model<IFactoryDocument>('Factory', factorySchema, 'factories');
