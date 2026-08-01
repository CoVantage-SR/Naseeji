import { Otp } from '../entities/otp.entity.js';

export interface IOtpRepository {
  save(otp: Otp): Promise<void>;
  findLatestByPhone(phone: string): Promise<Otp | null>;
  markAsUsed(id: string): Promise<void>;
}
