export type VerificationStatus = 'pending' | 'verified' | 'rejected' | 'need_more_documents';

export interface FactoryProps {
  id: string;
  userId: string;
  companyName: string;
  factoryType: string;
  governorate: string;
  city: string;
  address: string;
  commercialRegistration: string;
  taxNumber: string;
  logoUrl?: string;
  verificationStatus: VerificationStatus;
  verificationNotes?: string;
  createdAt: Date;
  updatedAt: Date;
}

export class Factory {
  private props: FactoryProps;

  constructor(props: FactoryProps) {
    this.props = props;
  }

  public get id(): string {
    return this.props.id;
  }
  public get userId(): string {
    return this.props.userId;
  }
  public get companyName(): string {
    return this.props.companyName;
  }
  public get factoryType(): string {
    return this.props.factoryType;
  }
  public get governorate(): string {
    return this.props.governorate;
  }
  public get city(): string {
    return this.props.city;
  }
  public get address(): string {
    return this.props.address;
  }
  public get commercialRegistration(): string {
    return this.props.commercialRegistration;
  }
  public get taxNumber(): string {
    return this.props.taxNumber;
  }
  public get logoUrl(): string | undefined {
    return this.props.logoUrl;
  }
  public get verificationStatus(): VerificationStatus {
    return this.props.verificationStatus;
  }
  public get verificationNotes(): string | undefined {
    return this.props.verificationNotes;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt;
  }

  public updateVerificationStatus(status: VerificationStatus, notes?: string): void {
    this.props.verificationStatus = status;
    if (notes) this.props.verificationNotes = notes;
    this.props.updatedAt = new Date();
  }

  public toJSON(): Record<string, unknown> {
    return { ...this.props };
  }
}
