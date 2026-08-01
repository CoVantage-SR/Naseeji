import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '../../../../database/mongo/base.schema.js';

export interface IUserDocument extends Document {
  _id: string;
  phone: string;
  email?: string;
  passwordHash?: string;
  status: string;
  accountType: string;
  profile?: {
    firstName: string;
    lastName: string;
    avatarUrl?: string;
    jobTitle?: string;
    preferredLanguage?: string;
  };
  companyReference?: {
    companyId: string;
    companyType: string;
  };
  roles: string[];
  createdAt: Date;
  updatedAt: Date;
}

const userSchema = new Schema<IUserDocument>(
  {
    _id: { type: String, required: true },
    phone: { type: String, required: true, unique: true, index: true },
    email: { type: String, unique: true, sparse: true, index: true },
    passwordHash: { type: String },
    status: { type: String, required: true, index: true },
    accountType: { type: String, required: true, index: true },
    profile: {
      firstName: { type: String },
      lastName: { type: String },
      avatarUrl: { type: String },
      jobTitle: { type: String },
      preferredLanguage: { type: String, default: 'ar' },
    },
    companyReference: {
      companyId: { type: String, index: true },
      companyType: { type: String },
    },
    roles: [{ type: String }],
  },
  baseSchemaOptions,
);

export const UserModel = model<IUserDocument>('User', userSchema, 'users');
