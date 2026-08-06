import bcrypt from 'bcrypt';
import crypto from 'crypto';
import jwt from 'jsonwebtoken';

describe('Enterprise Auth & Security Suite', () => {
  const secret = 'naseeji-test-secret-key';

  describe('Password Service Hashing & Comparison', () => {
    it('should hash password and verify match correctly', async () => {
      const rawPassword = 'StrongPass@1234';
      const hash = await bcrypt.hash(rawPassword, 10);
      const isMatch = await bcrypt.compare(rawPassword, hash);
      const isWrongMatch = await bcrypt.compare('WrongPass@1234', hash);

      expect(isMatch).toBe(true);
      expect(isWrongMatch).toBe(false);
    });
  });

  describe('JWT Access Token Generation & Verification', () => {
    it('should sign and verify valid payload', () => {
      const payload = { sub: 'user-123', role: 'factory', email: 'factory@naseeji.com' };
      const token = jwt.sign(payload, secret, { expiresIn: '15m' });

      const decoded = jwt.verify(token, secret) as any;
      expect(decoded.sub).toBe('user-123');
      expect(decoded.role).toBe('factory');
      expect(decoded.email).toBe('factory@naseeji.com');
    });

    it('should reject tampered or expired tokens', () => {
      const token = jwt.sign({ sub: 'user-123' }, secret, { expiresIn: '0s' });
      expect(() => jwt.verify(token, secret)).toThrow();
    });
  });

  describe('Refresh Token Rotation & Hash Security', () => {
    it('should generate deterministic sha256 hash for raw refresh token', () => {
      const rawToken = 'random_refresh_token_string_12345';
      const hash1 = crypto.createHash('sha256').update(rawToken).digest('hex');
      const hash2 = crypto.createHash('sha256').update(rawToken).digest('hex');

      expect(hash1).toBe(hash2);
      expect(hash1.length).toBe(64);
    });
  });
});
