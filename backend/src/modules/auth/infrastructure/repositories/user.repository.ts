import { UserModel, IUserDocument } from '../database/user.schema.js';

export class UserRepository {
  public async create(data: Partial<IUserDocument>): Promise<IUserDocument> {
    return await UserModel.create(data);
  }

  public async findById(id: string): Promise<IUserDocument | null> {
    return await UserModel.findOne({ _id: id, deletedAt: null });
  }

  public async findByEmail(email: string): Promise<IUserDocument | null> {
    return await UserModel.findOne({ email: email.toLowerCase(), deletedAt: null });
  }

  public async findByPhone(phone: string): Promise<IUserDocument | null> {
    return await UserModel.findOne({ phone, deletedAt: null });
  }

  public async update(id: string, updateData: Partial<IUserDocument>): Promise<IUserDocument | null> {
    return await UserModel.findOneAndUpdate({ _id: id, deletedAt: null }, updateData, { new: true });
  }

  public async softDelete(id: string): Promise<boolean> {
    const res = await UserModel.updateOne(
      { _id: id, deletedAt: null },
      { deletedAt: new Date(), status: 'deleted' },
    );
    return res.modifiedCount > 0;
  }
}
