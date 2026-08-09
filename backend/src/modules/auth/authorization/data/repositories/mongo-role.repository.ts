import mongoose from 'mongoose';
import { IRoleRepository } from '../../domain/repositories/role.repository.interface.js';
import { Role } from '../../domain/entities/role.entity.js';
import { RoleModel } from '../models/role.model.js';
import { RoleMapper } from '../mappers/role.mapper.js';
import { DEFAULT_ROLE_PERMISSIONS } from '../../../../../config/permissions.config.js';

export class MongoRoleRepository implements IRoleRepository {
  public async save(role: Role): Promise<void> {
    if (mongoose.connection.readyState !== 1) return;
    const raw = RoleMapper.toPersistence(role);
    await RoleModel.findByIdAndUpdate(role.id.value, raw, { upsert: true, new: true });
  }

  public async findByCode(code: string): Promise<Role | null> {
    if (mongoose.connection.readyState !== 1) {
      const upper = code.toUpperCase();
      const perms = DEFAULT_ROLE_PERMISSIONS[upper] || DEFAULT_ROLE_PERMISSIONS[code] || [];
      return Role.create(upper, upper, `${upper} Role`, true, perms);
    }
    const doc = await RoleModel.findOne({ code: code.toUpperCase() });
    return doc ? RoleMapper.toDomain(doc) : null;
  }

  public async findByCodes(codes: string[]): Promise<Role[]> {
    if (mongoose.connection.readyState !== 1) {
      return codes.map((c) => {
        const upper = c.toUpperCase();
        const perms = DEFAULT_ROLE_PERMISSIONS[upper] || DEFAULT_ROLE_PERMISSIONS[c] || [];
        return Role.create(upper, upper, `${upper} Role`, true, perms);
      });
    }
    const upperCodes = codes.map((c) => c.toUpperCase());
    const docs = await RoleModel.find({ code: { $in: upperCodes } });
    return docs.map((doc) => RoleMapper.toDomain(doc));
  }

  public async findAll(): Promise<Role[]> {
    if (mongoose.connection.readyState !== 1) {
      return Object.keys(DEFAULT_ROLE_PERMISSIONS).map((code) => {
        const upper = code.toUpperCase();
        return Role.create(upper, upper, `${upper} Role`, true, DEFAULT_ROLE_PERMISSIONS[code]);
      });
    }
    const docs = await RoleModel.find();
    return docs.map((doc) => RoleMapper.toDomain(doc));
  }
}
