import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IRoleDocument extends Document {
  _id: string;
  name: string; // 'factory' | 'supplier' | 'admin' | 'support' | 'auditor'
  description: string;
  permissions: string[]; // array of permission keys e.g. ['factory:read', 'factory:write']
  createdAt: Date;
  updatedAt: Date;
}

const roleSchema = new Schema<IRoleDocument>(
  {
    _id: { type: String, required: true },
    name: { type: String, required: true, unique: true, index: true },
    description: { type: String, required: true },
    permissions: [{ type: String, index: true }],
  },
  baseSchemaOptions,
);

export const RoleModel = model<IRoleDocument>('Role', roleSchema, 'roles');
