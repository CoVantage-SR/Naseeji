import { OtpCode } from '../value-objects/otp-code.vo.js';
import {
  OtpExpiredException,
  OtpInvalidException,
} from '../../../domain/errors/auth-domain.exceptions.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface OtpProps {
  id: string;
  phone: string;
  code: OtpCode;
  attempts: number;
  maxAttempts: number;
  isUsed: boolean;
  expiresAt: Date;
  createdAt: Date;
}

export class Otp {
  private props: OtpProps;

  private constructor(props: OtpProps) {
    this.props = props;
  }

  public static create(phone: string, durationMinutes = 5, maxAttempts = 3): Otp {
    const now = new Date();
    const expiresAt = new Date(now.getTime() + durationMinutes * 60 * 1000);
    return new Otp({
      id: UuidUtil.generate(),
      phone,
      code: OtpCode.generate(6),
      attempts: 0,
      maxAttempts,
      isUsed: false,
      expiresAt,
      createdAt: now,
    });
  }

  public static reconstitute(props: OtpProps): Otp {
    return new Otp(props);
  }

  public get id(): string {
    return this.props.id;
  }
  public get phone(): string {
    return this.props.phone;
  }
  public get code(): OtpCode {
    return this.props.code;
  }
  public get attempts(): number {
    return this.props.attempts;
  }
  public get isUsed(): boolean {
    return this.props.isUsed;
  }
  public get expiresAt(): Date {
    return this.props.expiresAt;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }

  public isExpired(): boolean {
    return new Date() > this.props.expiresAt;
  }

  public verify(inputCode: string): boolean {
    if (this.props.isUsed) {
      throw new OtpInvalidException('OTP code has already been used');
    }
    if (this.isExpired()) {
      throw new OtpExpiredException('OTP code has expired');
    }
    if (this.props.attempts >= this.props.maxAttempts) {
      throw new OtpInvalidException('Maximum OTP verification attempts exceeded');
    }

    this.props.attempts += 1;

    if (this.props.code.value !== inputCode) {
      throw new OtpInvalidException('Invalid OTP code');
    }

    this.props.isUsed = true;
    return true;
  }
}
