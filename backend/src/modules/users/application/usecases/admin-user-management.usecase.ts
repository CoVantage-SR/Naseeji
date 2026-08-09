import crypto from 'crypto';
import mongoose from 'mongoose';
import { UserModel, UserStatusType } from '../../../auth/infrastructure/database/user.schema.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../../auth/infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { SessionRepository } from '../../../auth/infrastructure/repositories/session.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import {
  ListUsersQueryDto,
  PaginatedUsersResponseDto,
  UserSummaryDto,
} from '../dtos/admin-user.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';

export class AdminUserManagementUseCase {
  constructor(
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private supplierRepo: SupplierRepository,
    private sessionRepo: SessionRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async listUsers(query: ListUsersQueryDto): Promise<PaginatedUsersResponseDto> {
    const page = Math.max(1, query.page || 1);
    const limit = Math.min(100, Math.max(1, query.limit || 20));
    const skip = (page - 1) * limit;

    if (mongoose.connection.readyState !== 1) {
      return {
        users: [],
        total: 0,
        page,
        limit,
        totalPages: 1,
      };
    }

    const filter: Record<string, unknown> = {};

    if (query.role) {
      filter.role = query.role;
    }

    if (query.status) {
      filter.status = query.status;
    }

    if (query.search) {
      const searchRegex = new RegExp(query.search.trim(), 'i');
      filter.$or = [{ email: searchRegex }, { phone: searchRegex }];
    }

    const [docs, total] = await Promise.all([
      UserModel.find(filter).sort({ createdAt: -1 }).skip(skip).limit(limit).lean(),
      UserModel.countDocuments(filter),
    ]);

    const users: UserSummaryDto[] = docs.map((doc) => ({
      id: doc._id,
      phone: doc.phone,
      email: doc.email,
      role: doc.role,
      status: doc.status,
      isEmailVerified: doc.isEmailVerified,
      isPhoneVerified: doc.isPhoneVerified,
      factoryId: doc.factoryId,
      supplierId: doc.supplierId,
      employeeId: doc.employeeId,
      createdAt: doc.createdAt ? doc.createdAt.toISOString() : undefined,
      updatedAt: doc.updatedAt ? doc.updatedAt.toISOString() : undefined,
    }));

    return {
      users,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit) || 1,
    };
  }

  public async getUserById(userId: string): Promise<Record<string, unknown>> {
    const user = await this.userRepo.findById(userId);
    if (!user) {
      throw new NotFoundException('User not found');
    }

    let profile: Record<string, unknown> | null = null;
    if (user.role === 'factory') {
      const f = await this.factoryRepo.findByUserId(user._id);
      if (f) {
        const obj = f as unknown as { toObject?: () => Record<string, unknown> };
        profile =
          typeof obj.toObject === 'function'
            ? obj.toObject()
            : (f as unknown as Record<string, unknown>);
      }
    } else if (user.role === 'supplier') {
      const s = await this.supplierRepo.findByUserId(user._id);
      if (s) {
        const obj = s as unknown as { toObject?: () => Record<string, unknown> };
        profile =
          typeof obj.toObject === 'function'
            ? obj.toObject()
            : (s as unknown as Record<string, unknown>);
      }
    }

    return {
      id: user._id,
      phone: user.phone,
      email: user.email,
      role: user.role,
      status: user.status,
      isEmailVerified: user.isEmailVerified,
      isPhoneVerified: user.isPhoneVerified,
      factoryId: user.factoryId,
      supplierId: user.supplierId,
      employeeId: user.employeeId,
      walletId: user.walletId,
      profile,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };
  }

  public async updateUserStatus(
    targetUserId: string,
    newStatus: UserStatusType,
    actorUserId: string,
    ipAddress: string,
    userAgent: string,
    reason?: string,
  ): Promise<{ success: boolean; message: string; user: Record<string, unknown> }> {
    const user = await this.userRepo.findById(targetUserId);
    if (!user) {
      throw new NotFoundException('Target user not found');
    }

    if (user._id === actorUserId) {
      throw new BusinessException('Administrative users cannot modify their own account status.');
    }

    const previousStatus = user.status;
    if (previousStatus === newStatus) {
      return {
        success: true,
        message: `User status is already ${newStatus}`,
        user: { id: user._id, status: user.status },
      };
    }

    await this.userRepo.update(targetUserId, { status: newStatus });

    if (['suspended', 'blocked', 'deactivated', 'rejected'].includes(newStatus)) {
      await this.sessionRepo.revokeAllUserSessions(targetUserId);
    }

    let actionCode = 'USER_STATUS_CHANGED';
    if (newStatus === 'suspended') actionCode = 'USER_SUSPENDED';
    else if (newStatus === 'blocked') actionCode = 'USER_BLOCKED';
    else if (newStatus === 'active') actionCode = 'USER_ACTIVATED';

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action: actionCode,
      ipAddress,
      userAgent,
      metadata: {
        targetUserId,
        previousStatus,
        newStatus,
        reason: reason || 'Administrative action',
      },
    });

    return {
      success: true,
      message: `User status successfully updated from ${previousStatus} to ${newStatus}`,
      user: {
        id: user._id,
        email: user.email,
        role: user.role,
        previousStatus,
        newStatus,
      },
    };
  }
}
