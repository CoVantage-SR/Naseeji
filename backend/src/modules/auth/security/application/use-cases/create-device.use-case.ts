import { IDeviceRepository } from '../../domain/repositories/device.repository.interface.js';
import { Device } from '../../domain/entities/device.entity.js';
import { FingerprintService } from '../../services/fingerprint.service.js';

export interface CreateDeviceCommand {
  userId: string;
  platform: string;
  deviceName: string;
  osVersion: string;
  appName: string;
  appVersion: string;
  ipAddress: string;
  pushToken?: string;
  country?: string;
  city?: string;
  timezone?: string;
  language?: string;
}

export class CreateDeviceUseCase {
  constructor(
    private deviceRepo: IDeviceRepository,
    private fingerprintService: FingerprintService,
  ) {}

  public async execute(command: CreateDeviceCommand): Promise<Device> {
    const fingerprint = this.fingerprintService.generateFingerprint(
      command.platform,
      command.osVersion,
      command.appName,
      command.appVersion,
    );

    const existingDevice = await this.deviceRepo.findByUserIdAndFingerprint(
      command.userId,
      fingerprint.hash,
    );

    if (existingDevice) {
      existingDevice.updateLastLogin(command.ipAddress);
      if (command.pushToken) {
        existingDevice.updatePushToken(command.pushToken);
      }
      await this.deviceRepo.save(existingDevice);
      return existingDevice;
    }

    const newDevice = Device.create(
      command.userId,
      command.platform,
      command.deviceName,
      command.osVersion,
      command.appName,
      command.appVersion,
      command.ipAddress,
      command.pushToken,
      command.country,
      command.city,
      command.timezone,
      command.language,
    );

    await this.deviceRepo.save(newDevice);
    return newDevice;
  }
}
