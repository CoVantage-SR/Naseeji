import crypto from 'crypto';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { VerificationRequestRepository } from '../../../auth/infrastructure/repositories/verification-request.repository.js';
import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../../auth/infrastructure/repositories/session.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { StoreRepository } from '../../infrastructure/repositories/store.repository.js';
import { AdminUpdateVerificationDto, AdminSupplierStatusDto } from '../dtos/supplier.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { IVerificationRequestDocument } from '../../../auth/infrastructure/database/verification-request.schema.js';

export class AdminSupplierManagementUseCase {
  constructor(
    private supplierRepo: SupplierRepository,
    private verificationRepo: VerificationRequestRepository,
    private userRepo: UserRepository,
    private sessionRepo: SessionRepository,
    private storeRepo: StoreRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async reviewVerificationRequest(
    requestId: string,
    dto: AdminUpdateVerificationDto,
    reviewerId: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<IVerificationRequestDocument> {
    const request = await this.verificationRepo.findById(requestId);
    if (!request) {
      throw new NotFoundException('Verification request not found');
    }

    const updatedRequest = await this.verificationRepo.updateStatus(
      requestId,
      dto.status,
      reviewerId,
      dto.notes,
    );

    if (!updatedRequest) {
      throw new NotFoundException('Failed to update verification request status');
    }

    if (request.entityType === 'supplier') {
      await this.supplierRepo.updateVerificationStatus(request.userId, dto.status, dto.notes);
      if (dto.status === 'verified') {
        await this.userRepo.update(request.userId, { status: 'active' });
      }
    }

    let actionCode = 'SUPPLIER_VERIFICATION_UPDATED';
    if (dto.status === 'verified') actionCode = 'SUPPLIER_VERIFICATION_APPROVED';
    else if (dto.status === 'rejected') actionCode = 'SUPPLIER_VERIFICATION_REJECTED';
    else if (dto.status === 'need_more_documents')
      actionCode = 'SUPPLIER_VERIFICATION_RESUBMISSION_REQUESTED';

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: reviewerId,
      action: actionCode,
      ipAddress,
      userAgent,
      metadata: {
        requestId,
        targetUserId: request.userId,
        status: dto.status,
        notes: dto.notes,
      },
    });

    return updatedRequest;
  }

  public async setSupplierActiveStatus(
    supplierId: string,
    dto: AdminSupplierStatusDto,
    actorUserId: string,
    ipAddress: string,
    userAgent: string,
  ): Promise<{ success: boolean; message: string }> {
    const supplier = await this.supplierRepo.findById(supplierId);
    if (!supplier) {
      throw new NotFoundException('Supplier not found');
    }

    await this.supplierRepo.updateActiveStatus(supplier.userId, dto.isActive);

    if (!dto.isActive) {
      // Suspend store and revoke supplier sessions if supplier is deactivated/suspended
      await this.storeRepo.updateStatus(supplier._id, 'suspended');
      await this.sessionRepo.revokeAllUserSessions(supplier.userId);
    } else {
      // Reactivate store
      await this.storeRepo.updateStatus(supplier._id, 'active');
    }

    const actionCode = dto.isActive ? 'SUPPLIER_REACTIVATED' : 'SUPPLIER_SUSPENDED';

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: actorUserId,
      action: actionCode,
      ipAddress,
      userAgent,
      metadata: {
        supplierId,
        targetUserId: supplier.userId,
        reason: dto.reason || 'Administrative action',
      },
    });

    return {
      success: true,
      message: `Supplier status successfully changed to ${dto.isActive ? 'active' : 'suspended'}`,
    };
  }
}
