import crypto from 'crypto';
import { DeviceModel, IDeviceDocument } from '../database/device.schema.js';

export interface RegisterDeviceDto {
  userId: string;
  deviceId: string;
  deviceName: string;
  deviceType?: 'android' | 'ios' | 'tablet' | 'browser';
  osVersion?: string;
  appVersion?: string;
  ipAddress: string;
  country?: string;
  city?: string;
  pushToken?: string;
  firebaseInstallationId?: string;
}

export class DeviceRepository {
  public async upsertDevice(dto: RegisterDeviceDto): Promise<IDeviceDocument> {
    const existing = await DeviceModel.findOne({
      userId: dto.userId,
      deviceId: dto.deviceId,
    });

    if (existing) {
      existing.deviceName = dto.deviceName;
      existing.deviceType = dto.deviceType || existing.deviceType;
      existing.osVersion = dto.osVersion || existing.osVersion;
      existing.appVersion = dto.appVersion || existing.appVersion;
      existing.ipAddress = dto.ipAddress;
      existing.country = dto.country || existing.country;
      existing.city = dto.city || existing.city;
      existing.pushToken = dto.pushToken || existing.pushToken;
      existing.firebaseInstallationId = dto.firebaseInstallationId || existing.firebaseInstallationId;
      existing.lastSeenAt = new Date();
      await existing.save();
      return existing;
    }

    const newDevice = new DeviceModel({
      _id: crypto.randomUUID(),
      userId: dto.userId,
      deviceId: dto.deviceId,
      deviceName: dto.deviceName,
      deviceType: dto.deviceType || 'android',
      osVersion: dto.osVersion || '1.0.0',
      appVersion: dto.appVersion || '1.0.0',
      ipAddress: dto.ipAddress,
      country: dto.country || 'Egypt',
      city: dto.city || 'Cairo',
      pushToken: dto.pushToken,
      firebaseInstallationId: dto.firebaseInstallationId,
      isTrusted: true,
      lastSeenAt: new Date(),
    });

    await newDevice.save();
    return newDevice;
  }

  public async findUserDevices(userId: string): Promise<IDeviceDocument[]> {
    return await DeviceModel.find({ userId }).sort({ lastSeenAt: -1 }).exec();
  }

  public async findDevice(userId: string, deviceId: string): Promise<IDeviceDocument | null> {
    return await DeviceModel.findOne({ userId, deviceId }).exec();
  }

  public async removeDevice(userId: string, deviceId: string): Promise<boolean> {
    const res = await DeviceModel.deleteOne({ userId, deviceId });
    return res.deletedCount > 0;
  }
}
