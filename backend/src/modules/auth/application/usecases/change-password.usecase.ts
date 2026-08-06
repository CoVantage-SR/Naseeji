import crypto from 'crypto';
import bcrypt from 'bcrypt';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { SessionRepository } from '../../infrastructure/repositories/session.repository.js';
import { RefreshTokenRepository } from '../../infrastructure/repositories/refresh-token.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

export interface ChangePasswordDto {
  userId: string;
  oldPassword: string;
  newPassword: string;
  ipAddress: string;
  userAgent: string;
}

export class ChangePasswordUseCase {
  constructor(
    private userRepo: UserRepository,
    private sessionRepo: SessionRepository,
    private refreshTokenRepo: RefreshTokenRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  public async execute(dto: ChangePasswordDto) {
    const user = await this.userRepo.findById(dto.userId);
    if (!user) {
      throw new Error('User not found');
    }

    const isValid = await bcrypt.compare(dto.oldPassword, user.passwordHash);
    if (!isValid) {
      throw new Error('Current password is incorrect');
    }

    const newPasswordHash = await bcrypt.hash(dto.newPassword, 12);
    await this.userRepo.update(user._id, { passwordHash: newPasswordHash });

    // Revoke existing sessions for security
    await this.sessionRepo.revokeAllUserSessions(user._id);
    await this.refreshTokenRepo.revokeAllForUser(user._id);

    await this.securityLogRepo.logAction({
      _id: crypto.randomUUID(),
      userId: user._id,
      action: 'password_change',
      ipAddress: dto.ipAddress,
      userAgent: dto.userAgent,
    });

    return { success: true, message: 'Password changed successfully. Please log in again.' };
  }
}
