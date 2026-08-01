import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IAuditLogDocument {
  _id: string;
  userId?: string;
  action: string;
  ipAddress: string;
  userAgent: string;
  traceId: string;
  metadata?: Record<string, unknown>;
  createdAt: Date;
}

const auditLogSchema = new Schema<IAuditLogDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, index: true },
    action: { type: String, required: true, index: true },
    ipAddress: { type: String, required: true },
    userAgent: { type: String, required: true },
    traceId: { type: String, required: true, index: true },
    metadata: { type: Schema.Types.Mixed },
  },
  baseSchemaOptions,
);

export const AuditLogModel = model<IAuditLogDocument>('AuditLog', auditLogSchema, 'audit_logs');
