import { JwtService, IssuedTokens } from '../../services/jwt.service.js';
import { IRefreshTokenRepository } from '../../domain/repositories/refresh-token.repository.interface.js';
import { RefreshTokenEntity } from '../../domain/entities/refresh-token.entity.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface IssueTokensCommand {
  userId: string;
  sessionId: string;
  accountType: string;
  roles: string[];
}

export class IssueAccessTokenUseCase {
  constructor(
    private jwtService: JwtService,
    private refreshTokenRepo: IRefreshTokenRepository,
  ) {}

  public async execute(command: IssueTokensCommand): Promise<IssuedTokens> {
    const tokens = this.jwtService.issueTokens(
      command.userId,
      command.sessionId,
      command.accountType,
      command.roles,
    );

    const refreshTokenEntity = RefreshTokenEntity.create(
      UuidUtil.generate(),
      tokens.jti,
      tokens.refreshToken,
      command.sessionId,
      command.userId,
      UuidUtil.generate(),
    );

    await this.refreshTokenRepo.save(refreshTokenEntity);
    return tokens;
  }
}
