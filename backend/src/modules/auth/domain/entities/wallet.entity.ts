export interface WalletProps {
  id: string;
  userId: string;
  balance: number;
  pointsBalance: number;
  currency: string;
  createdAt: Date;
  updatedAt: Date;
}

export class Wallet {
  private props: WalletProps;

  constructor(props: WalletProps) {
    this.props = props;
  }

  public get id(): string {
    return this.props.id;
  }
  public get userId(): string {
    return this.props.userId;
  }
  public get balance(): number {
    return this.props.balance;
  }
  public get pointsBalance(): number {
    return this.props.pointsBalance;
  }
  public get currency(): string {
    return this.props.currency;
  }
  public get createdAt(): Date {
    return this.props.createdAt;
  }
  public get updatedAt(): Date {
    return this.props.updatedAt;
  }

  public addPoints(points: number): void {
    this.props.pointsBalance += points;
    this.props.updatedAt = new Date();
  }

  public toJSON(): Record<string, unknown> {
    return { ...this.props };
  }
}
