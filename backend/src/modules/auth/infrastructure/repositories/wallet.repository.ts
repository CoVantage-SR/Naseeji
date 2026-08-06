import { WalletModel, IWalletDocument } from '../database/wallet.schema.js';

export class WalletRepository {
  public async create(data: Partial<IWalletDocument>): Promise<IWalletDocument> {
    return await WalletModel.create(data);
  }

  public async findByUserId(userId: string): Promise<IWalletDocument | null> {
    return await WalletModel.findOne({ userId });
  }

  public async addPoints(userId: string, points: number): Promise<IWalletDocument | null> {
    return await WalletModel.findOneAndUpdate(
      { userId },
      { $inc: { pointsBalance: points } },
      { new: true },
    );
  }
}
