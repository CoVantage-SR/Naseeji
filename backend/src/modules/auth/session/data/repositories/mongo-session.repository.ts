import { ISessionRepository } from '../../domain/repositories/session.repository.interface.js';
import { Session, SessionStatus } from '../../domain/entities/session.entity.js';
import { SessionModel } from '../models/session.model.js';
import { SessionMapper } from '../mappers/session.mapper.js';

export class MongoSessionRepository implements ISessionRepository {
  public async save(session: Session): Promise<void> {
    const raw = SessionMapper.toPersistence(session);
    await SessionModel.findByIdAndUpdate(session.id.value, raw, { upsert: true, new: true });
  }

  public async findById(id: string): Promise<Session | null> {
    const doc = await SessionModel.findById(id);
    return doc ? SessionMapper.toDomain(doc) : null;
  }

  public async findByUserId(userId: string): Promise<Session[]> {
    const docs = await SessionModel.find({ userId });
    return docs.map((doc) => SessionMapper.toDomain(doc));
  }

  public async findByUserIdAndDeviceId(userId: string, deviceId: string): Promise<Session | null> {
    const doc = await SessionModel.findOne({ userId, deviceId, status: SessionStatus.ACTIVE });
    return doc ? SessionMapper.toDomain(doc) : null;
  }

  public async revokeSession(id: string): Promise<void> {
    await SessionModel.findByIdAndUpdate(id, { status: SessionStatus.REVOKED });
  }

  public async revokeAllUserSessions(userId: string): Promise<void> {
    await SessionModel.updateMany({ userId }, { status: SessionStatus.REVOKED });
  }
}
