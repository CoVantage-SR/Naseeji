export interface UserProfileProps {
  firstName: string;
  lastName: string;
  avatarUrl?: string;
  jobTitle?: string;
  preferredLanguage?: string;
}

export class UserProfile {
  private props: UserProfileProps;

  constructor(props: UserProfileProps) {
    if (!props.firstName || !props.lastName) {
      throw new Error('User profile requires first name and last name');
    }
    this.props = {
      ...props,
      preferredLanguage: props.preferredLanguage || 'ar',
    };
  }

  public get firstName(): string {
    return this.props.firstName;
  }

  public get lastName(): string {
    return this.props.lastName;
  }

  public get fullName(): string {
    return `${this.props.firstName} ${this.props.lastName}`;
  }

  public get avatarUrl(): string | undefined {
    return this.props.avatarUrl;
  }

  public get jobTitle(): string | undefined {
    return this.props.jobTitle;
  }

  public get preferredLanguage(): string {
    return this.props.preferredLanguage || 'ar';
  }

  public updateProfile(updated: Partial<UserProfileProps>): void {
    this.props = { ...this.props, ...updated };
  }
}
