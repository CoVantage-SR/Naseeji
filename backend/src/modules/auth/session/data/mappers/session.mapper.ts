import { ISessionDocument } from '../models/session.model.js';
import { Session, SessionStatus } from '../../domain/entities/session.entity.js';
import { SessionId } from '../../domain/value-objects/session-id.vo.js';
import { DeviceId } from '../../../security/domain/value-objects/device-id.vo.js';

export class SessionMapper {
  public static toDomain(doc: ISessionDocument): Session {
    return Session.reconstitute({
      id: SessionId.create(doc._id),
      userId: doc.userId,
      deviceId: DeviceId.create(doc.deviceId),
      status: doc.status as SessionStatus,
      isRememberMe: doc.isRememberMe,
      ipAddress: doc.ipAddress,
      userAgent: doc.userAgent,
      expiresAt: doc.expiresAt,
      lastActiveAt: doc.lastActiveAt,
      createdAt: doc.createdAt,
      updatedAt: doc.updatedAt,
    });
  }

  public static toPersistence(session: Session): Record<string, unknown> {
    return {
      _id: session.id.value,
      userId: session.userId,
      deviceId: session.deviceId.value,
      status: session.status,
      isRememberMe: session.isRememberMe,
      ipAddress: session.ipAddress,
      userAgent: session.userAgent,
      expiresAt: session.expiresAt,
      lastActiveAt: session.lastActiveAt,
    };
  }
}
