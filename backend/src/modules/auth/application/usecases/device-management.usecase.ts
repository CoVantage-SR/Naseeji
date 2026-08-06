import crypto from 'crypto';
import { DeviceRepository } from '../../infrastructure/repositories/device.repository.js';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../infrastructure/repositories/wallet.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export class DeviceManagementUseCase {
  constructor(
    private deviceRepo: DeviceRepository,
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private supplierRepo: SupplierRepository,
    private walletRepo: WalletRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async getMe(userId: string): Promise<Record<string, unknown>> {
    const user = await this.userRepo.findById(userId);
    if (!user) {
      throw new Error('User account not found');
    }

    const profile =
      user.role === 'factory'
        ? await this.factoryRepo.findByUserId(userId)
        : await this.supplierRepo.findByUserId(userId);

    const wallet = await this.walletRepo.findByUserId(userId);
    const devices = await this.deviceRepo.findUserDevices(userId);

    return {
      user: {
        id: user._id,
        email: user.email,
        phone: user.phone,
        role: user.role,
        status: user.status,
        isEmailVerified: user.isEmailVerified,
        isPhoneVerified: user.isPhoneVerified,
      },
      profile,
      wallet: wallet
        ? { balance: wallet.balance, currency: wallet.currency, points: wallet.pointsBalance }
        : { balance: 0, currency: 'EGP', points: 100 },
      devicesCount: devices.length,
    };
  }

  public async getUserDevices(userId: string): Promise<Record<string, unknown>[]> {
    const devices = await this.deviceRepo.findUserDevices(userId);
    return devices.map((d) => ({
      id: d._id,
      deviceId: d.deviceId,
      deviceName: d.deviceName,
      deviceType: d.deviceType,
      osVersion: d.osVersion,
      appVersion: d.appVersion,
      ipAddress: d.ipAddress,
      country: d.country,
      city: d.city,
      isTrusted: d.isTrusted,
      lastSeenAt: d.lastSeenAt,
    }));
  }

  public async removeDevice(
    userId: string,
    deviceId: string,
    ip: string,
    userAgent: string,
  ): Promise<{ success: boolean; message: string }> {
    const removed = await this.deviceRepo.removeDevice(userId, deviceId);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'device_removed',
      ipAddress: ip,
      userAgent,
      metadata: { targetDeviceId: deviceId },
    });

    return {
      success: removed,
      message: removed ? 'Device successfully removed' : 'Device not found',
    };
  }
}
