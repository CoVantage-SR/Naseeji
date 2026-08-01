import crypto from 'crypto';

export class DeviceFingerprint {
  private readonly _hash: string;

  private constructor(hash: string) {
    this._hash = hash;
  }

  public static generate(
    platform: string,
    osVersion: string,
    appName: string,
    appVersion: string,
  ): DeviceFingerprint {
    const raw = `${platform.toLowerCase()}|${osVersion}|${appName}|${appVersion}`;
    const hash = crypto.createHash('sha256').update(raw).digest('hex');
    return new DeviceFingerprint(hash);
  }

  public static fromHash(hash: string): DeviceFingerprint {
    if (!hash || hash.length < 32) {
      throw new Error('Invalid DeviceFingerprint hash');
    }
    return new DeviceFingerprint(hash);
  }

  public get hash(): string {
    return this._hash;
  }

  public matches(other: DeviceFingerprint): boolean {
    return this._hash === other.hash;
  }
}
