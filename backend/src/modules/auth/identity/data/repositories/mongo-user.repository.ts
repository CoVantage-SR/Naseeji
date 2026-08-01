import { IUserRepository } from '../../domain/repositories/user.repository.interface.js';
import { User } from '../../domain/entities/user.entity.js';
import { UserModel } from '../models/user.model.js';
import { UserMapper } from '../mappers/user.mapper.js';

export class MongoUserRepository implements IUserRepository {
  public async save(user: User): Promise<void> {
    const raw = UserMapper.toPersistence(user);
    await UserModel.findByIdAndUpdate(user.id, raw, { upsert: true, new: true });
  }

  public async findById(id: string): Promise<User | null> {
    const doc = await UserModel.findById(id);
    return doc ? UserMapper.toDomain(doc) : null;
  }

  public async findByPhone(phone: string): Promise<User | null> {
    const doc = await UserModel.findOne({ phone });
    return doc ? UserMapper.toDomain(doc) : null;
  }

  public async findByEmail(email: string): Promise<User | null> {
    const doc = await UserModel.findOne({ email });
    return doc ? UserMapper.toDomain(doc) : null;
  }

  public async delete(id: string): Promise<void> {
    await UserModel.findByIdAndDelete(id);
  }
}
