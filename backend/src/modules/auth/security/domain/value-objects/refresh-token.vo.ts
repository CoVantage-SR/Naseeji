export class RefreshToken {
  private readonly _token: string;
  private readonly _jti: string;

  constructor(token: string, jti: string) {
    if (!token || !jti) {
      throw new Error('RefreshToken and JTI must not be empty');
    }
    this._token = token;
    this._jti = jti;
  }

  public get token(): string {
    return this._token;
  }

  public get jti(): string {
    return this._jti;
  }
}
