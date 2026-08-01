import { IPermissionRepository } from '../../domain/repositories/permission.repository.interface.js';
import { Permission } from '../../domain/entities/permission.entity.js';
import { PermissionModel } from '../models/permission.model.js';
import { PermissionMapper } from '../mappers/permission.mapper.js';

export class MongoPermissionRepository implements IPermissionRepository {
  public async save(permission: Permission): Promise<void> {
    const raw = PermissionMapper.toPersistence(permission);
    await PermissionModel.findByIdAndUpdate(permission.id.value, raw, {
      upsert: true,
      new: true,
    });
  }

  public async findByCode(code: string): Promise<Permission | null> {
    const doc = await PermissionModel.findOne({ code: code.toLowerCase() });
    return doc ? PermissionMapper.toDomain(doc) : null;
  }

  public async findByCodes(codes: string[]): Promise<Permission[]> {
    const lowerCodes = codes.map((c) => c.toLowerCase());
    const docs = await PermissionModel.find({ code: { $in: lowerCodes } });
    return docs.map((doc) => PermissionMapper.toDomain(doc));
  }

  public async findAll(): Promise<Permission[]> {
    const docs = await PermissionModel.find();
    return docs.map((doc) => PermissionMapper.toDomain(doc));
  }
}
