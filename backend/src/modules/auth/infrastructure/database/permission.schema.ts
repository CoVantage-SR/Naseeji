import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IPermissionDocument {
  _id: string;
  code: string;
  name?: string;
  group: string;
  description: string;
  createdAt?: Date;
  updatedAt?: Date;
}

const permissionSchema = new Schema<IPermissionDocument>(
  {
    _id: { type: String, required: true },
    code: { type: String, required: true, unique: true, index: true },
    name: { type: String },
    group: { type: String, required: true, index: true },
    description: { type: String, required: true },
  },
  baseSchemaOptions,
);

export const PermissionModel = model<IPermissionDocument>(
  'Permission',
  permissionSchema,
  'permissions',
);
