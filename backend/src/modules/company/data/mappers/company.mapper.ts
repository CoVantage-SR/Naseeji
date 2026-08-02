import { ICompanyDocument } from '../models/company.model.js';
import { Company } from '../../domain/entities/company.entity.js';
import { AccountType } from '../../../auth/identity/domain/value-objects/account-type.enum.js';

export class CompanyMapper {
  public static toDomain(doc: ICompanyDocument): Company {
    return Company.reconstitute({
      id: doc._id,
      name: doc.name,
      type: doc.type as AccountType,
      registrationNumber: doc.registrationNumber,
      ownerUserId: doc.ownerUserId,
      address: doc.address,
      city: doc.city,
      country: doc.country,
      isVerified: doc.isVerified,
      createdAt: doc.createdAt,
      updatedAt: doc.updatedAt,
    });
  }

  public static toPersistence(company: Company): Record<string, unknown> {
    return {
      _id: company.id,
      name: company.name,
      type: company.type,
      registrationNumber: company.registrationNumber,
      ownerUserId: company.ownerUserId,
      address: company.address,
      city: company.city,
      country: company.country,
      isVerified: company.isVerified,
    };
  }
}
