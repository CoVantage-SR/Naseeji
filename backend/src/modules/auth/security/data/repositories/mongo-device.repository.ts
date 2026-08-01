import { IDeviceRepository } from '../../domain/repositories/device.repository.interface.js';
import { Device } from '../../domain/entities/device.entity.js';
import { DeviceModel } from '../models/device.model.js';
import { DeviceMapper } from '../mappers/device.mapper.js';

export class MongoDeviceRepository implements IDeviceRepository {
  public async save(device: Device): Promise<void> {
    const raw = DeviceMapper.toPersistence(device);
    await DeviceModel.findByIdAndUpdate(device.id.value, raw, { upsert: true, new: true });
  }

  public async findById(id: string): Promise<Device | null> {
    const doc = await DeviceModel.findById(id);
    return doc ? DeviceMapper.toDomain(doc) : null;
  }

  public async findByUserId(userId: string): Promise<Device[]> {
    const docs = await DeviceModel.find({ userId });
    return docs.map((doc) => DeviceMapper.toDomain(doc));
  }

  public async findByUserIdAndFingerprint(
    userId: string,
    fingerprintHash: string,
  ): Promise<Device | null> {
    const doc = await DeviceModel.findOne({ userId, fingerprintHash });
    return doc ? DeviceMapper.toDomain(doc) : null;
  }
}
