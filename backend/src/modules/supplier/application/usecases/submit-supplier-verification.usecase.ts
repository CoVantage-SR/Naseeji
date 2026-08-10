import crypto from 'crypto';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { VerificationRequestRepository } from '../../../auth/infrastructure/repositories/verification-request.repository.js';
import { SecurityLogRepository } from '../../../auth/infrastructure/repositories/security-log.repository.js';
import { SubmitVerificationDto } from '../dtos/supplier.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { IVerificationRequestDocument } from '../../../auth/infrastructure/database/verification-request.schema.js';

export class SubmitSupplierVerificationUseCase {
  constructor(
    private supplierRepo: SupplierRepository,
    private verificationRepo: VerificationRequestRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(
    userId: string,
    dto: SubmitVerificationDto,
    ipAddress: string,
    userAgent: string,
  ): Promise<IVerificationRequestDocument> {
    const supplier = await this.supplierRepo.findByUserId(userId);
    if (!supplier) {
      throw new NotFoundException('Supplier profile not found');
    }

    const verificationRecord = await this.verificationRepo.create({
      _id: crypto.randomUUID(),
      userId,
      targetId: supplier._id,
      entityType: 'supplier',
      status: 'pending',
      commercialRegistration: dto.commercialRegistration,
      taxNumber: dto.taxNumber,
      documents: dto.documents,
      verificationNotes: dto.notes,
    });

    await this.supplierRepo.updateVerificationStatus(userId, 'pending', dto.notes);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId,
      action: 'SUPPLIER_VERIFICATION_SUBMITTED',
      ipAddress,
      userAgent,
      metadata: { supplierId: supplier._id, requestId: verificationRecord._id },
    });

    return verificationRecord;
  }
}
