import { IUserDocument } from '../models/user.model.js';
import { User } from '../../domain/entities/user.entity.js';
import { UserProfile } from '../../domain/entities/user-profile.entity.js';
import { Phone } from '../../domain/value-objects/phone.vo.js';
import { Password } from '../../domain/value-objects/password.vo.js';
import { AccountStatus } from '../../domain/value-objects/account-status.enum.js';
import { AccountType } from '../../domain/value-objects/account-type.enum.js';
import { CompanyReference } from '../../domain/value-objects/company-reference.vo.js';

export class UserMapper {
  public static toDomain(doc: IUserDocument): User {
    let profile: UserProfile | undefined;
    if (doc.profile && doc.profile.firstName && doc.profile.lastName) {
      profile = new UserProfile({
        firstName: doc.profile.firstName,
        lastName: doc.profile.lastName,
        avatarUrl: doc.profile.avatarUrl,
        jobTitle: doc.profile.jobTitle,
        preferredLanguage: doc.profile.preferredLanguage,
      });
    }

    let companyReference: CompanyReference | undefined;
    if (doc.companyReference && doc.companyReference.companyId) {
      companyReference = new CompanyReference(
        doc.companyReference.companyId,
        doc.companyReference.companyType as AccountType,
      );
    }

    return User.reconstitute({
      id: doc._id,
      phone: Phone.create(doc.phone),
      email: doc.email,
      password: doc.passwordHash ? Password.createHashed(doc.passwordHash) : undefined,
      status: doc.status as AccountStatus,
      accountType: doc.accountType as AccountType,
      profile,
      companyReference,
      roles: doc.roles || [],
      createdAt: doc.createdAt,
      updatedAt: doc.updatedAt,
    });
  }

  public static toPersistence(user: User): Record<string, unknown> {
    return {
      _id: user.id,
      phone: user.phone.value,
      email: user.email,
      passwordHash: user.password ? user.password.value : undefined,
      status: user.status,
      accountType: user.accountType,
      profile: user.profile
        ? {
            firstName: user.profile.firstName,
            lastName: user.profile.lastName,
            avatarUrl: user.profile.avatarUrl,
            jobTitle: user.profile.jobTitle,
            preferredLanguage: user.profile.preferredLanguage,
          }
        : undefined,
      companyReference: user.companyReference
        ? {
            companyId: user.companyReference.companyId,
            companyType: user.companyReference.companyType,
          }
        : undefined,
      roles: user.roles,
    };
  }
}
