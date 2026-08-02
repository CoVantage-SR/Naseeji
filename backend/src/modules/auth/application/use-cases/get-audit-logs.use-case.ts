import { IAuditLogRepository } from '../../../audit/domain/repositories/audit-log.repository.interface.js';
import { AuditLog } from '../../../audit/domain/entities/audit-log.entity.js';

export interface GetAuditLogsQuery {
  userId?: string;
  limit?: number;
  offset?: number;
}

export class GetAuditLogsUseCase {
  constructor(private auditLogRepo: IAuditLogRepository) {}

  public async execute(query: GetAuditLogsQuery): Promise<AuditLog[]> {
    if (query.userId) {
      return this.auditLogRepo.findByUserId(query.userId, query.limit || 50);
    }
    return this.auditLogRepo.findAll(query.limit || 100, query.offset || 0);
  }
}
