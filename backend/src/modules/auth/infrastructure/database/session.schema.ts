import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface ISessionDocument {
  _id: string;
  userId: string;
  refreshTokenHash: string;
  deviceId: string;
  deviceInfo: {
    browser?: string;
    os?: string;
    device?: string;
    userAgent: string;
  };
  ipAddress: string;
  country?: string;
  isRevoked: boolean;
  expiresAt: Date;
  lastActiveAt: Date;
  createdAt?: Date;
  updatedAt?: Date;
}

const sessionSchema = new Schema<ISessionDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, ref: 'User', index: true },
    refreshTokenHash: { type: String, required: true },
    deviceId: { type: String, required: true, index: true },
    deviceInfo: {
      browser: { type: String },
      os: { type: String },
      device: { type: String },
      userAgent: { type: String, required: true },
    },
    ipAddress: { type: String, required: true },
    country: { type: String, default: 'Egypt' },
    isRevoked: { type: Boolean, default: false, index: true },
    expiresAt: { type: Date, required: true, index: true },
    lastActiveAt: { type: Date, default: Date.now },
  },
  baseSchemaOptions,
);

export const SessionModel = model<ISessionDocument>('Session', sessionSchema, 'sessions');
