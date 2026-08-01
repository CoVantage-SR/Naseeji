import { ISessionRepository } from '../../domain/repositories/session.repository.interface.js';
import { Session } from '../../domain/entities/session.entity.js';
import { DeviceId } from '../../../security/domain/value-objects/device-id.vo.js';

export interface CreateSessionCommand {
  userId: string;
  deviceId: string;
  ipAddress: string;
  userAgent: string;
  isRememberMe?: boolean;
}

export class CreateSessionUseCase {
  constructor(private sessionRepo: ISessionRepository) {}

  public async execute(command: CreateSessionCommand): Promise<Session> {
    const session = Session.create(
      command.userId,
      DeviceId.create(command.deviceId),
      command.ipAddress,
      command.userAgent,
      command.isRememberMe ?? false,
    );

    await this.sessionRepo.save(session);
    return session;
  }
}
