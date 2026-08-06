import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IOtpDocument extends Document {
  _id: string;
  userId?: string;
  target: string; // phone number or email address
  type: 'phone_verification' | 'email_verification' | 'password_reset' | 'login_2fa';
  codeHash: string;
  expiresAt: Date;
  isUsed: boolean;
  attempts: number;
  createdAt: Date;
  updatedAt: Date;
}

const otpSchema = new Schema<IOtpDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, ref: 'User', index: true },
    target: { type: String, required: true, index: true },
    type: {
      type: String,
      enum: ['phone_verification', 'email_verification', 'password_reset', 'login_2fa'],
      required: true,
      index: true,
    },
    codeHash: { type: String, required: true },
    expiresAt: { type: Date, required: true, index: true },
    isUsed: { type: Boolean, default: false },
    attempts: { type: Number, default: 0 },
  },
  baseSchemaOptions,
);

export const OtpModel = model<IOtpDocument>('Otp', otpSchema, 'otps');
