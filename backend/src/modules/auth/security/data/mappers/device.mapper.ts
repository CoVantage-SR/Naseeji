import { IDeviceDocument } from '../models/device.model.js';
import { Device } from '../../domain/entities/device.entity.js';
import { DeviceId } from '../../domain/value-objects/device-id.vo.js';
import { DeviceFingerprint } from '../../domain/value-objects/device-fingerprint.vo.js';

export class DeviceMapper {
  public static toDomain(doc: IDeviceDocument): Device {
    return Device.reconstitute({
      id: DeviceId.create(doc._id),
      userId: doc.userId,
      platform: doc.platform,
      deviceName: doc.deviceName,
      osVersion: doc.osVersion,
      appName: doc.appName,
      appVersion: doc.appVersion,
      pushToken: doc.pushToken,
      ipAddress: doc.ipAddress,
      country: doc.country,
      city: doc.city,
      timezone: doc.timezone,
      language: doc.language,
      fingerprint: DeviceFingerprint.fromHash(doc.fingerprintHash),
      isTrusted: doc.isTrusted,
      lastLoginAt: doc.lastLoginAt,
      createdAt: doc.createdAt,
      updatedAt: doc.updatedAt,
    });
  }

  public static toPersistence(device: Device): Record<string, unknown> {
    return {
      _id: device.id.value,
      userId: device.userId,
      platform: device.platform,
      deviceName: device.deviceName,
      osVersion: device.osVersion,
      appName: device.appName,
      appVersion: device.appVersion,
      pushToken: device.pushToken,
      ipAddress: device.ipAddress,
      country: device.country,
      city: device.city,
      timezone: device.timezone,
      language: device.language,
      fingerprintHash: device.fingerprint.hash,
      isTrusted: device.isTrusted,
      lastLoginAt: device.lastLoginAt,
    };
  }
}
