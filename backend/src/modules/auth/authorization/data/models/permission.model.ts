import { Schema, model, Document } from 'mongoose';
import { baseSchemaOptions } from '../../../../database/mongo/base.schema.js';

export interface IPermissionDocument extends Document {
  _id: string;
  code: string;
  group: string;
  description: string;
  createdAt: Date;
}

const permissionSchema = new Schema<IPermissionDocument>(
  {
    _id: { type: String, required: true },
    code: { type: String, required: true, unique: true, index: true },
    group: { type: String, required: true, index: true },
    description: { type: String },
  },
  baseSchemaOptions,
);

export const PermissionModel = model<IPermissionDocument>(
  'Permission',
  permissionSchema,
  'permissions',
);
