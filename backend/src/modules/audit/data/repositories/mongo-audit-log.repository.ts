import { IAuditLogRepository } from '../../domain/repositories/audit-log.repository.interface.js';
import { AuditLog } from '../../domain/entities/audit-log.entity.js';
import { AuditLogModel } from '../models/audit-log.model.js';
import { AuditLogMapper } from '../mappers/audit-log.mapper.js';

export class MongoAuditLogRepository implements IAuditLogRepository {
  public async save(auditLog: AuditLog): Promise<void> {
    const raw = AuditLogMapper.toPersistence(auditLog);
    await AuditLogModel.findByIdAndUpdate(auditLog.id, raw, { upsert: true, new: true });
  }

  public async findByUserId(userId: string, limit = 50): Promise<AuditLog[]> {
    const docs = await AuditLogModel.find({ userId }).sort({ createdAt: -1 }).limit(limit);
    return docs.map((doc) => AuditLogMapper.toDomain(doc));
  }

  public async findAll(limit = 100, offset = 0): Promise<AuditLog[]> {
    const docs = await AuditLogModel.find().sort({ createdAt: -1 }).skip(offset).limit(limit);
    return docs.map((doc) => AuditLogMapper.toDomain(doc));
  }
}
