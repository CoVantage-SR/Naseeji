import { DeviceFingerprint } from '../domain/value-objects/device-fingerprint.vo.js';

export class FingerprintService {
  public generateFingerprint(
    platform: string,
    osVersion: string,
    appName: string,
    appVersion: string,
  ): DeviceFingerprint {
    return DeviceFingerprint.generate(platform, osVersion, appName, appVersion);
  }

  public matches(fingerprintA: DeviceFingerprint, fingerprintB: DeviceFingerprint): boolean {
    return fingerprintA.matches(fingerprintB);
  }
}
