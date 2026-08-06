import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface ISecurityLogDocument extends Document {
  _id: string;
  userId?: string;
  action: string;
  ipAddress: string;
  userAgent: string;
  device?: string;
  browser?: string;
  country?: string;
  metadata?: Record<string, any>;
  createdAt: Date;
}

const securityLogSchema = new Schema<ISecurityLogDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, ref: 'User', index: true },
    action: { type: String, required: true, index: true },
    ipAddress: { type: String, required: true, index: true },
    userAgent: { type: String, required: true },
    device: { type: String },
    browser: { type: String },
    country: { type: String, default: 'Egypt' },
    metadata: { type: Schema.Types.Mixed },
  },
  baseSchemaOptions,
);

export const SecurityLogModel = model<ISecurityLogDocument>('SecurityLog', securityLogSchema, 'security_logs');
