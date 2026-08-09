import crypto from 'crypto';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../../auth/infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { GetMeUseCase } from './get-me.usecase.js';
import { UpdateMeDto, GetMeResponseDto } from '../dtos/user.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';

export class UpdateMeUseCase {
  constructor(
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private supplierRepo: SupplierRepository,
    private securityLogRepo: SecurityLogRepository,
    private getMeUseCase: GetMeUseCase,
  ) {}

  public async execute(
    userId: string,
    dto: UpdateMeDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<GetMeResponseDto> {
    const user = await this.userRepo.findById(userId);
    if (!user) {
      throw new NotFoundException('User profile not found');
    }

    const updates: Record<string, unknown> = {};

    // 1. Email update check & normalization
    if (dto.email && dto.email.toLowerCase().trim() !== user.email) {
      const normalizedEmail = dto.email.toLowerCase().trim();
      const existingEmail = await this.userRepo.findByEmail(normalizedEmail);
      if (existingEmail && existingEmail._id !== userId) {
        throw new BusinessException('Email is already registered by another account');
      }
      updates.email = normalizedEmail;
      updates.isEmailVerified = false;
    }

    // 2. Phone update check & normalization
    if (dto.phone) {
      const normalizedPhone = dto.phone.replace(/\s+/g, '').replace(/[^\d+]/g, '');
      if (normalizedPhone !== user.phone) {
        const existingPhone = await this.userRepo.findByPhone(normalizedPhone);
        if (existingPhone && existingPhone._id !== userId) {
          throw new BusinessException('Phone number is already registered by another account');
        }
        updates.phone = normalizedPhone;
        updates.isPhoneVerified = false;
      }
    }

    if (Object.keys(updates).length > 0) {
      await this.userRepo.update(userId, updates);
    }

    // 3. Profile organization updates (whitelisted fields only)
    const profileUpdates: Record<string, unknown> = {};
    if (dto.companyName) profileUpdates.companyName = dto.companyName;
    if (dto.governorate) profileUpdates.governorate = dto.governorate;
    if (dto.city) profileUpdates.city = dto.city;
    if (dto.address) profileUpdates.address = dto.address;
    if (dto.country) profileUpdates.country = dto.country;
    if (dto.logoUrl !== undefined) profileUpdates.logoUrl = dto.logoUrl;

    if (Object.keys(profileUpdates).length > 0) {
      if (user.role === 'factory') {
        await this.factoryRepo.updateByUserId(userId, profileUpdates);
      } else if (user.role === 'supplier') {
        await this.supplierRepo.updateByUserId(userId, profileUpdates);
      }
    }

    // 4. Audit Log
    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'USER_UPDATED',
      ipAddress,
      userAgent,
      metadata: { fieldsUpdated: [...Object.keys(updates), ...Object.keys(profileUpdates)] },
    });

    return await this.getMeUseCase.execute(userId);
  }
}
