import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IWalletDocument {
  _id: string;
  userId: string;
  balance: number;
  pointsBalance: number;
  currency: string;
  createdAt?: Date;
  updatedAt?: Date;
}

const walletSchema = new Schema<IWalletDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, ref: 'User', unique: true, index: true },
    balance: { type: Number, default: 0, min: 0 },
    pointsBalance: { type: Number, default: 0, min: 0 },
    currency: { type: String, default: 'EGP' },
  },
  baseSchemaOptions,
);

export const WalletModel = model<IWalletDocument>('Wallet', walletSchema, 'wallets');
