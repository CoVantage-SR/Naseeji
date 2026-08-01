import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '../../../../database/mongo/base.schema.js';

export interface IOtpDocument extends Document {
  _id: string;
  phone: string;
  code: string;
  attempts: number;
  maxAttempts: number;
  isUsed: boolean;
  expiresAt: Date;
  createdAt: Date;
}

const otpSchema = new Schema<IOtpDocument>(
  {
    _id: { type: String, required: true },
    phone: { type: String, required: true, index: true },
    code: { type: String, required: true },
    attempts: { type: Number, default: 0 },
    maxAttempts: { type: Number, default: 3 },
    isUsed: { type: Boolean, default: false, index: true },
    expiresAt: { type: Date, required: true, index: { expires: 0 } }, // TTL Index
  },
  baseSchemaOptions,
);

export const OtpModel = model<IOtpDocument>('Otp', otpSchema, 'otp_codes');
