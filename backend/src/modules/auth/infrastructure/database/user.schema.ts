import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export type UserRoleType = 'factory' | 'supplier' | 'admin' | 'support' | 'auditor';
export type UserStatusType = 'active' | 'pending' | 'deactivated' | 'deleted' | 'suspended';

export interface IUserDocument extends Document {
  _id: string;
  phone: string;
  email: string;
  passwordHash: string;
  role: UserRoleType;
  status: UserStatusType;
  isEmailVerified: boolean;
  isPhoneVerified: boolean;
  factoryId?: string;
  supplierId?: string;
  walletId?: string;
  createdAt: Date;
  updatedAt: Date;
  deletedAt?: Date;
}

const userSchema = new Schema<IUserDocument>(
  {
    _id: { type: String, required: true },
    phone: { type: String, required: true, unique: true, index: true },
    email: { type: String, required: true, unique: true, index: true, lowercase: true, trim: true },
    passwordHash: { type: String, required: true },
    role: { type: String, enum: ['factory', 'supplier', 'admin', 'support', 'auditor'], required: true, index: true },
    status: { type: String, enum: ['active', 'pending', 'deactivated', 'deleted', 'suspended'], default: 'pending', index: true },
    isEmailVerified: { type: Boolean, default: false },
    isPhoneVerified: { type: Boolean, default: false },
    factoryId: { type: String, ref: 'Factory', index: true },
    supplierId: { type: String, ref: 'Supplier', index: true },
    walletId: { type: String, ref: 'Wallet', index: true },
    deletedAt: { type: Date, default: null },
  },
  baseSchemaOptions,
);

export const UserModel = model<IUserDocument>('User', userSchema, 'users');
