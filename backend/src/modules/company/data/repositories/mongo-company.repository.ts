import { ClientSession } from 'mongoose';
import { ICompanyRepository } from '../../domain/repositories/company.repository.interface.js';
import { Company } from '../../domain/entities/company.entity.js';
import { CompanyModel } from '../models/company.model.js';
import { CompanyMapper } from '../mappers/company.mapper.js';

export class MongoCompanyRepository implements ICompanyRepository {
  public async save(company: Company, session?: ClientSession | null): Promise<void> {
    const raw = CompanyMapper.toPersistence(company);
    await CompanyModel.findByIdAndUpdate(company.id, raw, {
      upsert: true,
      new: true,
      session: session || undefined,
    });
  }

  public async findById(id: string): Promise<Company | null> {
    const doc = await CompanyModel.findById(id);
    return doc ? CompanyMapper.toDomain(doc) : null;
  }

  public async findByRegistrationNumber(registrationNumber: string): Promise<Company | null> {
    const doc = await CompanyModel.findOne({ registrationNumber });
    return doc ? CompanyMapper.toDomain(doc) : null;
  }
}
