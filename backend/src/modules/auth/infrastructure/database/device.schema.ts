import mongoose, { Schema } from 'mongoose';

export interface IDeviceDocument {
  _id: string;
  userId: string;
  deviceId: string;
  deviceName: string;
  deviceType: 'android' | 'ios' | 'tablet' | 'browser';
  osVersion: string;
  appVersion: string;
  ipAddress: string;
  country?: string;
  city?: string;
  pushToken?: string;
  firebaseInstallationId?: string;
  isTrusted: boolean;
  lastSeenAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

const DeviceSchema = new Schema<IDeviceDocument>(
  {
    _id: { type: String, required: true },
    userId: { type: String, required: true, index: true },
    deviceId: { type: String, required: true, index: true },
    deviceName: { type: String, required: true },
    deviceType: {
      type: String,
      enum: ['android', 'ios', 'tablet', 'browser'],
      default: 'android',
    },
    osVersion: { type: String, default: '1.0.0' },
    appVersion: { type: String, default: '1.0.0' },
    ipAddress: { type: String, required: true },
    country: { type: String, default: 'Egypt' },
    city: { type: String, default: 'Cairo' },
    pushToken: { type: String },
    firebaseInstallationId: { type: String },
    isTrusted: { type: Boolean, default: true },
    lastSeenAt: { type: Date, default: Date.now },
  },
  {
    timestamps: true,
    _id: false,
  },
);

DeviceSchema.index({ userId: 1, deviceId: 1 }, { unique: true });

export const DeviceModel = mongoose.model<IDeviceDocument>('Device', DeviceSchema);
