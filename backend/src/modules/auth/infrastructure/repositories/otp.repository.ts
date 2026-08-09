import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { RedisService } from '../../../../infrastructure/redis/redis.service.js';
import { OtpModel, IOtpDocument } from '../database/otp.schema.js';

/** Shape stored in Redis for an OTP record */
interface RedisOtpRecord {
  codeHash: string;
  attempts: number;
  userId?: string;
  expiresAt: number; // unix timestamp ms
}

/**
 * OtpRepository — stores OTP codes primarily in Redis for fast access and automatic expiration.
 * Falls back to MongoDB when Redis is unavailable (e.g., test environments).
 *
 * Redis key format: otp:{target}:{type}
 * Cooldown key format: otp:cooldown:{target}:{type}
 */
export class OtpRepository {
  private get redis() {
    return RedisService.getInstance().getClient();
  }

  private get otpTtlSeconds(): number {
    return parseInt(process.env.OTP_TTL_SECONDS || '300', 10);
  }

  private get maxAttempts(): number {
    return parseInt(process.env.OTP_MAX_ATTEMPTS || '5', 10);
  }

  private get resendCooldownSeconds(): number {
    return parseInt(process.env.OTP_RESEND_COOLDOWN_SECONDS || '60', 10);
  }

  // ─── Redis helpers ──────────────────────────────────────────────────────────

  private redisKey(target: string, type: string): string {
    return `otp:${target}:${type}`;
  }

  private cooldownKey(target: string, type: string): string {
    return `otp:cooldown:${target}:${type}`;
  }

  // ─── Public API ─────────────────────────────────────────────────────────────

  /**
   * Creates a new OTP. Enforces resend cooldown.
   * Stores in Redis (primary) or MongoDB (fallback).
   */
  public async create(data: Partial<IOtpDocument>): Promise<IOtpDocument> {
    const target = data.target!;
    const type = data.type!;

    // Enforce resend cooldown
    const cooldown = await this.checkCooldown(target, type);
    if (cooldown.active) {
      throw new Error(
        `Please wait ${cooldown.remainingSeconds}s before requesting a new OTP code.`,
      );
    }

    const client = this.redis;
    if (client) {
      const record: RedisOtpRecord = {
        codeHash: data.codeHash!,
        attempts: 0,
        userId: data.userId,
        expiresAt: Date.now() + this.otpTtlSeconds * 1000,
      };
      await client.set(this.redisKey(target, type), JSON.stringify(record), 'EX', this.otpTtlSeconds);
      // Set cooldown key
      await client.set(this.cooldownKey(target, type), '1', 'EX', this.resendCooldownSeconds);

      // Return a virtual document matching IOtpDocument interface
      return {
        _id: data._id || crypto.randomUUID(),
        target,
        type,
        codeHash: data.codeHash!,
        expiresAt: new Date(record.expiresAt),
        isUsed: false,
        attempts: 0,
        userId: data.userId,
      } as IOtpDocument;
    }

    // MongoDB fallback
    return await OtpModel.create(data);
  }

  /**
   * Finds the most recent valid (non-expired, non-used) OTP for a target+type.
   */
  public async findValidOtp(
    target: string,
    type: string,
  ): Promise<IOtpDocument | null> {
    const client = this.redis;
    if (client) {
      const raw = await client.get(this.redisKey(target, type));
      if (!raw) return null;

      const record = JSON.parse(raw) as RedisOtpRecord;
      if (record.expiresAt < Date.now()) {
        await client.del(this.redisKey(target, type));
        return null;
      }

      if (record.attempts >= this.maxAttempts) {
        await client.del(this.redisKey(target, type));
        throw new Error('Maximum OTP retry attempts exceeded. Please request a new code.');
      }

      return {
        _id: this.redisKey(target, type),
        target,
        type,
        codeHash: record.codeHash,
        expiresAt: new Date(record.expiresAt),
        isUsed: false,
        attempts: record.attempts,
        userId: record.userId,
      } as IOtpDocument;
    }

    // MongoDB fallback
    return await OtpModel.findOne({
      target,
      type,
      isUsed: false,
      expiresAt: { $gt: new Date() },
    }).sort({ createdAt: -1 });
  }

  /**
   * Marks the OTP as used / consumed. Deletes from Redis.
   */
  public async markAsUsed(id: string): Promise<void> {
    const client = this.redis;
    if (client) {
      // id is the Redis key when using Redis backend
      await client.del(id);
      return;
    }
    await OtpModel.updateOne({ _id: id }, { isUsed: true });
  }

  /**
   * Increments the attempt counter for the OTP.
   */
  public async incrementAttempts(id: string): Promise<void> {
    const client = this.redis;
    if (client) {
      const raw = await client.get(id);
      if (!raw) return;
      const record = JSON.parse(raw) as RedisOtpRecord;
      record.attempts += 1;
      const ttlRemaining = Math.floor((record.expiresAt - Date.now()) / 1000);
      if (ttlRemaining > 0) {
        await client.set(id, JSON.stringify(record), 'EX', ttlRemaining);
      } else {
        await client.del(id);
      }
      return;
    }
    await OtpModel.updateOne({ _id: id }, { $inc: { attempts: 1 } });
  }

  /**
   * Checks whether a resend cooldown is active for the given target+type.
   */
  public async checkCooldown(
    target: string,
    type: string,
  ): Promise<{ active: boolean; remainingSeconds?: number }> {
    const client = this.redis;
    if (!client) return { active: false };

    const ttl = await client.ttl(this.cooldownKey(target, type));
    if (ttl > 0) {
      return { active: true, remainingSeconds: ttl };
    }
    return { active: false };
  }

  /**
   * Generates a 6-digit OTP code, hashes it, and stores it.
   * Returns both the raw code (for dispatch) and the stored document.
   */
  public async generateOtp(
    target: string,
    type: IOtpDocument['type'],
    userId?: string,
  ): Promise<{ code: string; document: IOtpDocument }> {
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const codeHash = await bcrypt.hash(code, 10);
    const expiresAt = new Date(Date.now() + this.otpTtlSeconds * 1000);

    const document = await this.create({
      _id: crypto.randomUUID(),
      target,
      type,
      codeHash,
      expiresAt,
      isUsed: false,
      attempts: 0,
      ...(userId ? { userId } : {}),
    });

    return { code, document };
  }
}
