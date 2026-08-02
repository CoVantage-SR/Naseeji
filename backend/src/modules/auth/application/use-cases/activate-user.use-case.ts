import { IUserRepository } from '../../identity/domain/repositories/user.repository.interface.js';
import { AuditLogService } from '../../../audit/services/audit-log.service.js';
import { AuditAction } from '../../../audit/domain/value-objects/audit-action.enum.js';
import { NotFoundException } from '@core/errors/not-found.exception.js';

export interface ActivateUserCommand {
  adminUserId: string;
  targetUserId: string;
  ipAddress: string;
  userAgent: string;
}

export class ActivateUserUseCase {
  constructor(
    private userRepo: IUserRepository,
    private auditLogService: AuditLogService,
  ) {}

  public async execute(command: ActivateUserCommand): Promise<void> {
    const user = await this.userRepo.findById(command.targetUserId);
    if (!user) {
      throw new NotFoundException(`User with ID ${command.targetUserId} not found`);
    }

    user.activate();
    await this.userRepo.save(user);

    await this.auditLogService.log(
      AuditAction.ACCOUNT_ACTIVATED,
      command.ipAddress,
      command.userAgent,
      command.adminUserId,
      { targetUserId: user.id },
    );
  }
}
