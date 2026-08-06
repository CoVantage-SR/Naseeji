import { VerificationStatus } from './factory.entity.js';

export type SubscriptionStatus = 'active' | 'inactive' | 'suspended' | 'trial';

export interface SupplierProps {
  id: string;
  userId: string;
  companyName: string;
  supplierCategory: string;
  phone: string;
  email?: string;
  commercialRegistration: string;
  taxNumber: string;
  country: string;
  governorate: string;
  address: string;
  verificationStatus: VerificationStatus;
  verificationNotes?: string;
  subscriptionStatus: SubscriptionStatus;
  createdAt: Date;
  updatedAt: Date;
}

export class Supplier {
  private props: SupplierProps;

  constructor(props: SupplierProps) {
    this.props = props;
  }

  public get id(): string { return this.props.id; }
  public get userId(): string { return this.props.userId; }
  public get companyName(): string { return this.props.companyName; }
  public get supplierCategory(): string { return this.props.supplierCategory; }
  public get phone(): string { return this.props.phone; }
  public get email(): string | undefined { return this.props.email; }
  public get commercialRegistration(): string { return this.props.commercialRegistration; }
  public get taxNumber(): string { return this.props.taxNumber; }
  public get country(): string { return this.props.country; }
  public get governorate(): string { return this.props.governorate; }
  public get address(): string { return this.props.address; }
  public get verificationStatus(): VerificationStatus { return this.props.verificationStatus; }
  public get verificationNotes(): string | undefined { return this.props.verificationNotes; }
  public get subscriptionStatus(): SubscriptionStatus { return this.props.subscriptionStatus; }
  public get createdAt(): Date { return this.props.createdAt; }
  public get updatedAt(): Date { return this.props.updatedAt; }

  public updateVerificationStatus(status: VerificationStatus, notes?: string): void {
    this.props.verificationStatus = status;
    if (notes) this.props.verificationNotes = notes;
    this.props.updatedAt = new Date();
  }

  public toJSON() {
    return { ...this.props };
  }
}
