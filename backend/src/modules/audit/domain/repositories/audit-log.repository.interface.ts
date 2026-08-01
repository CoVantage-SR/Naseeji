import { AuditLog } from '../entities/audit-log.entity.js';

export interface IAuditLogRepository {
  save(auditLog: AuditLog): Promise<void>;
  findByUserId(userId: string, limit?: number): Promise<AuditLog[]>;
  findAll(limit?: number, offset?: number): Promise<AuditLog[]>;
}
