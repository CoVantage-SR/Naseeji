import { JwtService } from '../../src/modules/auth/security/services/jwt.service';

describe('JwtService Unit Tests', () => {
  const jwtService = new JwtService('test-secret-key-123456');

  it('should issue valid access and refresh tokens with JTI', () => {
    const tokens = jwtService.issueTokens('user-123', 'session-456', 'Factory', ['FACTORY_ADMIN']);
    expect(tokens.accessToken).toBeDefined();
    expect(tokens.refreshToken).toBeDefined();
    expect(tokens.jti).toBeDefined();

    const decoded = jwtService.verifyToken(tokens.accessToken);
    expect(decoded.sub).toBe('user-123');
    expect(decoded.sessionId).toBe('session-456');
    expect(decoded.accountType).toBe('Factory');
  });
});
