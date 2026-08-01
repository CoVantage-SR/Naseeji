import { AccountType } from './account-type.enum.js';

export class CompanyReference {
  private readonly _companyId: string;
  private readonly _companyType: AccountType;

  constructor(companyId: string, companyType: AccountType) {
    if (!companyId) {
      throw new Error('companyId cannot be empty');
    }
    this._companyId = companyId;
    this._companyType = companyType;
  }

  public get companyId(): string {
    return this._companyId;
  }

  public get companyType(): AccountType {
    return this._companyType;
  }
}
