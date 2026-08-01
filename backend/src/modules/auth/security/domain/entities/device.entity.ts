import { DeviceId } from '../value-objects/device-id.vo.js';
import { DeviceFingerprint } from '../value-objects/device-fingerprint.vo.js';

export interface DeviceProps {
  id: DeviceId;
  userId: string;
  platform: string;
  deviceName: string;
  osVersion: string;
  appName: string;
  appVersion: string;
  pushToken?: string;
  ipAddress: string;
  country?: string;
  city?: string;
  timezone?: string;
  language?: string;
  fingerprint: DeviceFingerprint;
  isTrusted: boolean;
  lastLoginAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

export class Device {
  private props: DeviceProps;

  private constructor(props: DeviceProps) {
    this.props = props;
  }

  public static create(
    userId: string,
    platform: string,
    deviceName: string,
    osVersion: string,
    appName: string,
    appVersion: string,
    ipAddress: string,
    pushToken?: string,
    country?: string,
    city?: string,
    timezone?: string,
    language?: string,
  ): Device {
    const now = new Date();
    const fingerprint = DeviceFingerprint.generate(platform, osVersion, appName, appVersion);

    return new Device({
      id: DeviceId.create(),
      userId,
      platform,
      deviceName,
      osVersion,
      appName,
      appVersion,
      pushToken,
      ipAddress,
      country,
      city,
      timezone,
      language: language || 'ar',
      fingerprint,
      isTrusted: true,
      lastLoginAt: now,
      createdAt: now,
      updatedAt: now,
    });
  }

  public static reconstitute(props: DeviceProps): Device {
    return new Device(props);
  }

  public get id(): DeviceId {
    return this.props.id;
  }
  public get userId(): string {
    return this.props.userId;
  }
  public get platform(): string {
    return this.props.platform;
  }
  public get deviceName(): string {
    return this.props.deviceName;
  }
  public get osVersion(): string {
    return this.props.osVersion;
  }
  public get appName(): string {
    return this.props.appName;
  }
  public get appVersion(): string {
    return this.props.appVersion;
  }
  public get pushToken(): string | undefined {
    return this.props.pushToken;
  }
  public get ipAddress(): string {
    return this.props.ipAddress;
  }
  public get country(): string | undefined {
    return this.props.country;
  }
  public get city(): string | undefined {
    return this.props.city;
  }
  public get timezone(): string | undefined {
    return this.props.timezone;
  }
  public get language(): string | undefined {
    return this.props.language;
  }
  public get fingerprint(): DeviceFingerprint {
    return this.props.fingerprint;
  }
  public get isTrusted(): boolean {
    return this.props.isTrusted;
  }
  public get lastLoginAt(): Date {
    return this.props.lastLoginAt;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt;
  }

  public updateLastLogin(ipAddress: string): void {
    this.props.ipAddress = ipAddress;
    this.props.lastLoginAt = new Date();
    this.props.updatedAt = new Date();
  }

  public updatePushToken(pushToken: string): void {
    this.props.pushToken = pushToken;
    this.props.updatedAt = new Date();
  }

  public markUntrusted(): void {
    this.props.isTrusted = false;
    this.props.updatedAt = new Date();
  }
}
