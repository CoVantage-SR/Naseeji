import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IRefreshTokenDocument {
  _id: string;
  userId: string;
  sessionId: string;
  tokenHash: string;
  familyId: string;
  isUsed: boolean;
  isRevoked: boolean;
  expiresAt: Date;
  createdAt?: Date;
  updatedAt?: Date;
}

const refreshTokenSchema = new Schema<IRefreshTokenDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, ref: 'User', index: true },
    sessionId: { type: String, required: true, ref: 'Session', index: true },
    tokenHash: { type: String, required: true, unique: true, index: true },
    familyId: { type: String, required: true, index: true },
    isUsed: { type: Boolean, default: false },
    isRevoked: { type: Boolean, default: false, index: true },
    expiresAt: { type: Date, required: true, index: true },
  },
  baseSchemaOptions,
);

export const RefreshTokenModel = model<IRefreshTokenDocument>(
  'RefreshToken',
  refreshTokenSchema,
  'refresh_tokens',
);
