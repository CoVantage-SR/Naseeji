import { IRoleRepository } from '../../domain/repositories/role.repository.interface.js';
import { Role } from '../../domain/entities/role.entity.js';
import { RoleModel } from '../models/role.model.js';
import { RoleMapper } from '../mappers/role.mapper.js';

export class MongoRoleRepository implements IRoleRepository {
  public async save(role: Role): Promise<void> {
    const raw = RoleMapper.toPersistence(role);
    await RoleModel.findByIdAndUpdate(role.id.value, raw, { upsert: true, new: true });
  }

  public async findByCode(code: string): Promise<Role | null> {
    const doc = await RoleModel.findOne({ code: code.toUpperCase() });
    return doc ? RoleMapper.toDomain(doc) : null;
  }

  public async findByCodes(codes: string[]): Promise<Role[]> {
    const upperCodes = codes.map((c) => c.toUpperCase());
    const docs = await RoleModel.find({ code: { $in: upperCodes } });
    return docs.map((doc) => RoleMapper.toDomain(doc));
  }

  public async findAll(): Promise<Role[]> {
    const docs = await RoleModel.find();
    return docs.map((doc) => RoleMapper.toDomain(doc));
  }
}
