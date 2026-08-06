import { OtpModel, IOtpDocument } from '../database/otp.schema.js';

export class OtpRepository {
  public async create(data: Partial<IOtpDocument>): Promise<IOtpDocument> {
    return await OtpModel.create(data);
  }

  public async findValidOtp(target: string, type: string): Promise<IOtpDocument | null> {
    return await OtpModel.findOne({
      target,
      type,
      isUsed: false,
      expiresAt: { $gt: new Date() },
    }).sort({ createdAt: -1 });
  }

  public async markAsUsed(id: string): Promise<void> {
    await OtpModel.updateOne({ _id: id }, { isUsed: true });
  }

  public async incrementAttempts(id: string): Promise<void> {
    await OtpModel.updateOne({ _id: id }, { $inc: { attempts: 1 } });
  }
}
