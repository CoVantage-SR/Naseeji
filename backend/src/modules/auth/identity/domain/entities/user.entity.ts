import { Phone } from '../value-objects/phone.vo.js';
import { Password } from '../value-objects/password.vo.js';
import { AccountStatus } from '../value-objects/account-status.enum.js';
import { AccountType } from '../value-objects/account-type.enum.js';
import { CompanyReference } from '../value-objects/company-reference.vo.js';
import { UserProfile } from './user-profile.entity.js';
import { UuidUtil } from '../../../../core/utils/uuid.util.js';

export interface UserProps {
  id: string;
  phone: Phone;
  email?: string;
  password?: Password;
  status: AccountStatus;
  accountType: AccountType;
  profile?: UserProfile;
  companyReference?: CompanyReference;
  roles: string[];
  createdAt: Date;
  updatedAt: Date;
}

export class User {
  private props: UserProps;

  private constructor(props: UserProps) {
    this.props = props;
  }

  public static createNew(
    phone: Phone,
    accountType: AccountType,
    email?: string,
    password?: Password,
    companyRef?: CompanyReference,
  ): User {
    const now = new Date();
    return new User({
      id: UuidUtil.generate(),
      phone,
      email,
      password,
      status: AccountStatus.PENDING,
      accountType,
      companyReference: companyRef,
      roles: [],
      createdAt: now,
      updatedAt: now,
    });
  }

  public static reconstitute(props: UserProps): User {
    return new User(props);
  }

  public get id(): string {
    return this.props.id;
  }
  public get phone(): Phone {
    return this.props.phone;
  }
  public get email(): string | undefined {
    return this.props.email;
  }
  public get password(): Password | undefined {
    return this.props.password;
  }
  public get status(): AccountStatus {
    return this.props.status;
  }
  public get accountType(): AccountType {
    return this.props.accountType;
  }
  public get profile(): UserProfile | undefined {
    return this.props.profile;
  }
  public get companyReference(): CompanyReference | undefined {
    return this.props.companyReference;
  }
  public get roles(): string[] {
    return [...this.props.roles];
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt;
  }

  // Domain Rules & Status Transitions
  public verifyPhone(): void {
    if (this.props.status === AccountStatus.PENDING) {
      this.props.status = AccountStatus.PROFILE_INCOMPLETE;
      this.props.updatedAt = new Date();
    }
  }

  public activate(): void {
    if (this.props.status === AccountStatus.BLOCKED) {
      throw new Error('Cannot activate a blocked account directly');
    }
    this.props.status = AccountStatus.ACTIVE;
    this.props.updatedAt = new Date();
  }

  public suspend(): void {
    this.props.status = AccountStatus.SUSPENDED;
    this.props.updatedAt = new Date();
  }

  public block(): void {
    this.props.status = AccountStatus.BLOCKED;
    this.props.updatedAt = new Date();
  }

  public assignRole(roleCode: string): void {
    if (!this.props.roles.includes(roleCode)) {
      this.props.roles.push(roleCode);
      this.props.updatedAt = new Date();
    }
  }

  public updateProfile(profile: UserProfile): void {
    this.props.profile = profile;
    if (this.props.status === AccountStatus.PROFILE_INCOMPLETE) {
      this.props.status = AccountStatus.ACTIVE;
    }
    this.props.updatedAt = new Date();
  }
}
