import { Device } from '../entities/device.entity.js';

export interface IDeviceRepository {
  save(device: Device): Promise<void>;
  findById(id: string): Promise<Device | null>;
  findByUserId(userId: string): Promise<Device[]>;
  findByUserIdAndFingerprint(userId: string, fingerprintHash: string): Promise<Device | null>;
}
