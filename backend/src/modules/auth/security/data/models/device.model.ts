import { Schema, model } from 'mongoose';
import { baseSchemaOptions } from '@database/mongo/base.schema.js';

export interface IDeviceDocument {
  _id: string;
  userId: string;
  platform: string;
  deviceName: string;
  osVersion: string;
  appName: string;
  appVersion: string;
  pushToken?: string;
  ipAddress: string;
  country?: string;
  city?: string;
  timezone?: string;
  language?: string;
  fingerprintHash: string;
  isTrusted: boolean;
  lastLoginAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

const deviceSchema = new Schema<IDeviceDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, index: true },
    platform: { type: String, required: true },
    deviceName: { type: String, required: true },
    osVersion: { type: String, required: true },
    appName: { type: String, required: true },
    appVersion: { type: String, required: true },
    pushToken: { type: String },
    ipAddress: { type: String, required: true },
    country: { type: String },
    city: { type: String },
    timezone: { type: String },
    language: { type: String, default: 'ar' },
    fingerprintHash: { type: String, required: true, index: true },
    isTrusted: { type: Boolean, default: true },
    lastLoginAt: { type: Date, required: true },
  },
  baseSchemaOptions,
);

export const DeviceModel = model<IDeviceDocument>('Device', deviceSchema, 'devices');
