import { IAuditLogDocument } from '../models/audit-log.model.js';
import { AuditLog } from '../../domain/entities/audit-log.entity.js';
import { AuditAction } from '../../domain/value-objects/audit-action.enum.js';

export class AuditLogMapper {
  public static toDomain(doc: IAuditLogDocument): AuditLog {
    return AuditLog.reconstitute({
      id: doc._id,
      userId: doc.userId,
      action: doc.action as AuditAction,
      ipAddress: doc.ipAddress,
      userAgent: doc.userAgent,
      traceId: doc.traceId,
      metadata: doc.metadata,
      createdAt: doc.createdAt,
    });
  }

  public static toPersistence(auditLog: AuditLog): Record<string, unknown> {
    return {
      _id: auditLog.id,
      userId: auditLog.userId,
      action: auditLog.action,
      ipAddress: auditLog.ipAddress,
      userAgent: auditLog.userAgent,
      traceId: auditLog.traceId,
      metadata: auditLog.metadata,
    };
  }
}
