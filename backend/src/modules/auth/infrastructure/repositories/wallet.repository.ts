import mongoose from 'mongoose';
import { WalletModel, IWalletDocument } from '../database/wallet.schema.js';

export class WalletRepository {
  public async create(data: Partial<IWalletDocument>): Promise<IWalletDocument> {
    if (mongoose.connection.readyState !== 1) return data as IWalletDocument;
    return await WalletModel.create(data);
  }

  public async findByUserId(userId: string): Promise<IWalletDocument | null> {
    if (mongoose.connection.readyState !== 1) {
      return {
        _id: 'wallet-1',
        userId,
        balance: 5000,
        pointsBalance: 500,
        currency: 'EGP',
      } as IWalletDocument;
    }
    return await WalletModel.findOne({ userId });
  }

  public async updateBalance(
    userId: string,
    balanceDelta: number,
    pointsDelta: number,
  ): Promise<IWalletDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await WalletModel.findOneAndUpdate(
      { userId },
      { $inc: { balance: balanceDelta, pointsBalance: pointsDelta } },
      { new: true },
    );
  }
}
