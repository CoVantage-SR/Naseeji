import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface ICompanyDocument {
  _id: string;
  name: string;
  type: string;
  registrationNumber: string;
  ownerUserId: string;
  address?: string;
  city?: string;
  country?: string;
  isVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const companySchema = new Schema<ICompanyDocument>(
  {
    _id: { type: String, required: true },
    name: { type: String, required: true, index: true },
    type: { type: String, required: true, index: true },
    registrationNumber: { type: String, required: true, unique: true, index: true },
    ownerUserId: { type: String, required: true, index: true },
    address: { type: String },
    city: { type: String },
    country: { type: String },
    isVerified: { type: Boolean, default: false },
  },
  baseSchemaOptions,
);

export const CompanyModel = model<ICompanyDocument>('Company', companySchema, 'companies');
