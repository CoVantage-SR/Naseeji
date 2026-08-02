import { AccountType } from '../../../auth/identity/domain/value-objects/account-type.enum.js';
import { UuidUtil } from '@core/utils/uuid.util.js';

export interface CompanyProps {
  id: string;
  name: string;
  type: AccountType;
  registrationNumber: string;
  ownerUserId: string;
  address?: string;
  city?: string;
  country?: string;
  isVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
}

export class Company {
  private props: CompanyProps;

  private constructor(props: CompanyProps) {
    this.props = props;
  }

  public static create(
    name: string,
    type: AccountType,
    registrationNumber: string,
    ownerUserId: string,
    address?: string,
    city?: string,
    country?: string,
  ): Company {
    const now = new Date();
    return new Company({
      id: UuidUtil.generate(),
      name,
      type,
      registrationNumber,
      ownerUserId,
      address,
      city,
      country,
      isVerified: false,
      createdAt: now,
      updatedAt: now,
    });
  }

  public static reconstitute(props: CompanyProps): Company {
    return new Company(props);
  }

  public get id(): string {
    return this.props.id;
  }
  public get name(): string {
    return this.props.name;
  }
  public get type(): AccountType {
    return this.props.type;
  }
  public get registrationNumber(): string {
    return this.props.registrationNumber;
  }
  public get ownerUserId(): string {
    return this.props.ownerUserId;
  }
  public get address(): string | undefined {
    return this.props.address;
  }
  public get city(): string | undefined {
    return this.props.city;
  }
  public get country(): string | undefined {
    return this.props.country;
  }
  public get isVerified(): boolean {
    return this.props.isVerified;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt;
  }

  public verifyCompany(): void {
    this.props.isVerified = true;
    this.props.updatedAt = new Date();
  }
}
