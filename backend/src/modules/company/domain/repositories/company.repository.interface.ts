import { ClientSession } from 'mongoose';
import { Company } from '../entities/company.entity.js';

export interface ICompanyRepository {
  save(company: Company, session?: ClientSession | null): Promise<void>;
  findById(id: string): Promise<Company | null>;
  findByRegistrationNumber(registrationNumber: string): Promise<Company | null>;
}
