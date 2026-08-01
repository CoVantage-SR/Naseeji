import { IOtpDocument } from '../models/otp.model.js';
import { Otp } from '../../domain/entities/otp.entity.js';
import { OtpCode } from '../../domain/value-objects/otp-code.vo.js';

export class OtpMapper {
  public static toDomain(doc: IOtpDocument): Otp {
    return Otp.reconstitute({
      id: doc._id,
      phone: doc.phone,
      code: OtpCode.create(doc.code),
      attempts: doc.attempts,
      maxAttempts: doc.maxAttempts,
      isUsed: doc.isUsed,
      expiresAt: doc.expiresAt,
      createdAt: doc.createdAt,
    });
  }

  public static toPersistence(otp: Otp): Record<string, unknown> {
    return {
      _id: otp.id,
      phone: otp.phone,
      code: otp.code.value,
      attempts: otp.attempts,
      isUsed: otp.isUsed,
      expiresAt: otp.expiresAt,
    };
  }
}
