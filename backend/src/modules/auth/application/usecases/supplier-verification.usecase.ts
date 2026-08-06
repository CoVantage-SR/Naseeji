import crypto from 'crypto';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { VerificationRequestRepository } from '../../infrastructure/repositories/verification-request.repository.js';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';
import { IVerificationRequestDocument } from '../../infrastructure/database/verification-request.schema.js';

export interface UpdateVerificationDto {
  requestId: string;
  status: 'pending' | 'verified' | 'rejected' | 'need_more_documents';
  reviewerId: string;
  notes?: string;
  ipAddress: string;
  userAgent: string;
}

export class SupplierVerificationUseCase {
  constructor(
    private verificationRepo: VerificationRequestRepository,
    private supplierRepo: SupplierRepository,
    private factoryRepo: FactoryRepository,
    private userRepo: UserRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async updateStatus(
    dto: UpdateVerificationDto,
  ): Promise<IVerificationRequestDocument | null> {
    const request = await this.verificationRepo.findById(dto.requestId);
    if (!request) {
      throw new Error('Verification request not found');
    }

    const updatedRequest = await this.verificationRepo.updateStatus(
      dto.requestId,
      dto.status,
      dto.reviewerId,
      dto.notes,
    );

    if (request.entityType === 'supplier') {
      await this.supplierRepo.updateVerificationStatus(request.targetId, dto.status, dto.notes);
    } else if (request.entityType === 'factory') {
      await this.factoryRepo.updateVerificationStatus(request.targetId, dto.status, dto.notes);
    }

    if (dto.status === 'verified') {
      await this.userRepo.update(request.userId, { status: 'active' });
    }

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: dto.reviewerId,
      action: 'verification_updated',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
      metadata: { targetUserId: request.userId, status: dto.status, notes: dto.notes },
    });

    return updatedRequest;
  }

  public async getPendingRequests(): Promise<IVerificationRequestDocument[]> {
    return await this.verificationRepo.findPendingRequests();
  }
}
