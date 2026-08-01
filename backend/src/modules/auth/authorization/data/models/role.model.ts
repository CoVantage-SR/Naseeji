import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '../../../../database/mongo/base.schema.js';

export interface IRoleDocument extends Document {
  _id: string;
  code: string;
  name: string;
  description: string;
  isSystemRole: boolean;
  permissionCodes: string[];
  createdAt: Date;
  updatedAt: Date;
}

const roleSchema = new Schema<IRoleDocument>(
  {
    _id: { type: String, required: true },
    code: { type: String, required: true, unique: true, index: true },
    name: { type: String, required: true },
    description: { type: String },
    isSystemRole: { type: Boolean, default: false },
    permissionCodes: [{ type: String }],
  },
  baseSchemaOptions,
);

export const RoleModel = model<IRoleDocument>('Role', roleSchema, 'roles');
