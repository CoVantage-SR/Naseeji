import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export type EmployeeStatusType = 'active' | 'suspended' | 'deactivated';
export type OrganizationType = 'factory' | 'supplier';

export interface IEmployeeDocument {
  _id: string;
  userId: string;
  organizationId: string;
  organizationType: OrganizationType;
  fullName: string;
  email: string;
  phone: string;
  position?: string;
  role: string;
  permissions: string[];
  status: EmployeeStatusType;
  createdAt?: Date;
  updatedAt?: Date;
}

const employeeSchema = new Schema<IEmployeeDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, unique: true, ref: 'User', index: true },
    organizationId: { type: String, required: true, index: true },
    organizationType: {
      type: String,
      enum: ['factory', 'supplier'],
      required: true,
      index: true,
    },
    fullName: { type: String, required: true },
    email: { type: String, required: true, lowercase: true, trim: true, index: true },
    phone: { type: String, required: true, index: true },
    position: { type: String, default: 'Employee' },
    role: { type: String, required: true, default: 'employee', index: true },
    permissions: [{ type: String }],
    status: {
      type: String,
      enum: ['active', 'suspended', 'deactivated'],
      default: 'active',
      index: true,
    },
  },
  baseSchemaOptions,
);

export const EmployeeModel = model<IEmployeeDocument>('Employee', employeeSchema, 'employees');
