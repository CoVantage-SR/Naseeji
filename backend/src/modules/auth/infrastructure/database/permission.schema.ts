import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IPermissionDocument {
  _id: string;
  key: string;
  description: string;
  module: string;
  createdAt?: Date;
  updatedAt?: Date;
}

const permissionSchema = new Schema<IPermissionDocument>(
  {
    _id: { type: String, required: true },
    key: { type: String, required: true, unique: true, index: true },
    description: { type: String, required: true },
    module: { type: String, required: true, index: true },
  },
  baseSchemaOptions,
);

export const PermissionModel = model<IPermissionDocument>(
  'Permission',
  permissionSchema,
  'permissions',
);
