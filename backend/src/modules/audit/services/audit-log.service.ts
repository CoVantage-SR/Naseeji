import { IAuditLogRepository } from '../domain/repositories/audit-log.repository.interface.js';
import { AuditLog } from '../domain/entities/audit-log.entity.js';
import { AuditAction } from '../domain/value-objects/audit-action.enum.js';
import { RequestContext } from '@core/context/request-context.js';
import { WinstonLogger } from '@core/logger/winston.logger.js';

export class AuditLogService {
  constructor(private auditLogRepo: IAuditLogRepository) {}

  public async log(
    action: AuditAction,
    ipAddress: string,
    userAgent: string,
    userId?: string,
    metadata?: Record<string, unknown>,
  ): Promise<void> {
    const logger = WinstonLogger.getInstance();
    const traceId = RequestContext.getTraceId();

    logger.info(`[AUDIT LOG] ${action}`, {
      userId,
      ipAddress,
      traceId,
      metadata,
    });

    const logEntity = AuditLog.create(action, ipAddress, userAgent, traceId, userId, metadata);

    try {
      await this.auditLogRepo.save(logEntity);
    } catch (error) {
      logger.error('Failed to write audit log entry to database', {
        error: (error as Error).message,
        action,
        userId,
      });
    }
  }
}
