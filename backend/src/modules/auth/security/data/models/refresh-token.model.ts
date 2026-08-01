import { Schema, model } from 'mongoose';

export interface IRefreshTokenDocument {
  _id: string;
  jti: string;
  token: string;
  sessionId: string;
  userId: string;
  tokenFamilyId: string;
  isUsed: boolean;
  isRevoked: boolean;
  expiresAt: Date;
  createdAt: Date;
}

const refreshTokenSchema = new Schema<IRefreshTokenDocument>(
  {
    _id: { type: String, required: true },
    jti: { type: String, required: true, unique: true, index: true },
    token: { type: String, required: true },
    sessionId: { type: String, required: true, index: true },
    userId: { type: String, required: true, index: true },
    tokenFamilyId: { type: String, required: true, index: true },
    isUsed: { type: Boolean, default: false },
    isRevoked: { type: Boolean, default: false, index: true },
    expiresAt: { type: Date, required: true, index: { expires: 0 } },
  },
  { timestamps: true },
);

export const RefreshTokenModel = model<IRefreshTokenDocument>(
  'RefreshToken',
  refreshTokenSchema,
  'refresh_tokens',
);
