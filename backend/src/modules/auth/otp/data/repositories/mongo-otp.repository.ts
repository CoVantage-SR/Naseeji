import { IOtpRepository } from '../../domain/repositories/otp.repository.interface.js';
import { Otp } from '../../domain/entities/otp.entity.js';
import { OtpModel } from '../models/otp.model.js';
import { OtpMapper } from '../mappers/otp.mapper.js';

export class MongoOtpRepository implements IOtpRepository {
  public async save(otp: Otp): Promise<void> {
    const raw = OtpMapper.toPersistence(otp);
    await OtpModel.findByIdAndUpdate(otp.id, raw, { upsert: true, new: true });
  }

  public async findLatestByPhone(phone: string): Promise<Otp | null> {
    const doc = await OtpModel.findOne({ phone, isUsed: false }).sort({ createdAt: -1 });
    return doc ? OtpMapper.toDomain(doc) : null;
  }

  public async markAsUsed(id: string): Promise<void> {
    await OtpModel.findByIdAndUpdate(id, { isUsed: true });
  }
}
