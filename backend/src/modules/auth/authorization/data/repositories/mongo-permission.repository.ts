import mongoose from 'mongoose';
import { IPermissionRepository } from '../../domain/repositories/permission.repository.interface.js';
import { Permission } from '../../domain/entities/permission.entity.js';
import { PermissionModel } from '../models/permission.model.js';
import { PermissionMapper } from '../mappers/permission.mapper.js';
import { PERMISSIONS_CATALOG } from '../../../../../config/permissions.config.js';

export class MongoPermissionRepository implements IPermissionRepository {
  public async save(permission: Permission): Promise<void> {
    if (mongoose.connection.readyState !== 1) return;
    const raw = PermissionMapper.toPersistence(permission);
    await PermissionModel.findByIdAndUpdate(permission.id.value, raw, {
      upsert: true,
      new: true,
    });
  }

  public async findByCode(code: string): Promise<Permission | null> {
    if (mongoose.connection.readyState !== 1) {
      const p = PERMISSIONS_CATALOG.find((item) => item.code === code.toLowerCase());
      return p ? Permission.create(p.code, p.group, p.description) : null;
    }
    const doc = await PermissionModel.findOne({ code: code.toLowerCase() });
    return doc ? PermissionMapper.toDomain(doc) : null;
  }

  public async findByCodes(codes: string[]): Promise<Permission[]> {
    if (mongoose.connection.readyState !== 1) {
      const lowerCodes = codes.map((c) => c.toLowerCase());
      return PERMISSIONS_CATALOG.filter((p) => lowerCodes.includes(p.code)).map((p) =>
        Permission.create(p.code, p.group, p.description),
      );
    }
    const lowerCodes = codes.map((c) => c.toLowerCase());
    const docs = await PermissionModel.find({ code: { $in: lowerCodes } });
    return docs.map((doc) => PermissionMapper.toDomain(doc));
  }

  public async findAll(): Promise<Permission[]> {
    if (mongoose.connection.readyState !== 1) {
      return PERMISSIONS_CATALOG.map((p) => Permission.create(p.code, p.group, p.description));
    }
    const docs = await PermissionModel.find();
    return docs.map((doc) => PermissionMapper.toDomain(doc));
  }
}
