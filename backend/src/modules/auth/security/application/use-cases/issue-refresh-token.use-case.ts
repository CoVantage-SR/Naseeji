import { JwtService, IssuedTokens } from '../../services/jwt.service.js';
import { IRefreshTokenRepository } from '../../domain/repositories/refresh-token.repository.interface.js';
import { RefreshTokenEntity } from '../../domain/entities/refresh-token.entity.js';
import { SessionExpiredException } from '../../../domain/errors/auth-domain.exceptions.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface RotateTokenCommand {
  refreshToken: string;
}

export class IssueRefreshTokenUseCase {
  constructor(
    private jwtService: JwtService,
    private refreshTokenRepo: IRefreshTokenRepository,
  ) {}

  public async execute(command: RotateTokenCommand): Promise<IssuedTokens> {
    const payload = this.jwtService.verifyToken(command.refreshToken);
    if (!payload.jti) {
      throw new SessionExpiredException('Invalid refresh token payload');
    }

    const existingToken = await this.refreshTokenRepo.findByJti(payload.jti);

    if (!existingToken || !existingToken.isValid()) {
      if (existingToken && existingToken.isUsed) {
        await this.refreshTokenRepo.revokeFamily(existingToken.tokenFamilyId);
      }
      throw new SessionExpiredException('Refresh token is invalid, used, or expired');
    }

    existingToken.markUsed();
    await this.refreshTokenRepo.save(existingToken);

    const newTokens = this.jwtService.issueTokens(
      payload.sub,
      payload.sessionId || '',
      payload.accountType || '',
      payload.roles || [],
    );

    const newTokenEntity = RefreshTokenEntity.create(
      UuidUtil.generate(),
      newTokens.jti,
      newTokens.refreshToken,
      payload.sessionId || '',
      payload.sub,
      existingToken.tokenFamilyId,
    );

    await this.refreshTokenRepo.save(newTokenEntity);
    return newTokens;
  }
}
