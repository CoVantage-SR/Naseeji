import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IVerificationRequestDocument {
  _id: string;
  userId: string;
  targetId: string;
  entityType: 'factory' | 'supplier';
  status: 'pending' | 'verified' | 'rejected' | 'need_more_documents';
  commercialRegistration: string;
  taxNumber: string;
  documents: { documentType: string; url: string }[];
  verificationNotes?: string;
  reviewedBy?: string;
  reviewedAt?: Date;
  createdAt?: Date;
  updatedAt?: Date;
}

const verificationRequestSchema = new Schema<IVerificationRequestDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, ref: 'User', index: true },
    targetId: { type: String, required: true, index: true },
    entityType: { type: String, enum: ['factory', 'supplier'], required: true },
    status: {
      type: String,
      enum: ['pending', 'verified', 'rejected', 'need_more_documents'],
      default: 'pending',
      index: true,
    },
    commercialRegistration: { type: String, required: true },
    taxNumber: { type: String, required: true },
    documents: [{ documentType: { type: String }, url: { type: String } }],
    verificationNotes: { type: String },
    reviewedBy: { type: String, ref: 'User' },
    reviewedAt: { type: Date },
  },
  baseSchemaOptions,
);

export const VerificationRequestModel = model<IVerificationRequestDocument>(
  'VerificationRequest',
  verificationRequestSchema,
  'verification_requests',
);
