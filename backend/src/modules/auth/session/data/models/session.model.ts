import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '../../../../database/mongo/base.schema.js';

export interface ISessionDocument extends Document {
  _id: string;
  userId: string;
  deviceId: string;
  status: string;
  isRememberMe: boolean;
  ipAddress: string;
  userAgent: string;
  expiresAt: Date;
  lastActiveAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

const sessionSchema = new Schema<ISessionDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, index: true },
    deviceId: { type: String, required: true, index: true },
    status: { type: String, required: true, index: true },
    isRememberMe: { type: Boolean, default: false },
    ipAddress: { type: String, required: true },
    userAgent: { type: String, required: true },
    expiresAt: { type: Date, required: true, index: { expires: 0 } }, // MongoDB TTL Index
    lastActiveAt: { type: Date, required: true },
  },
  baseSchemaOptions,
);

export const SessionModel = model<ISessionDocument>('Session', sessionSchema, 'sessions');
