type Factory<T> = (container: DIContainer) => T;

export class DIContainer {
  private static instance: DIContainer;
  private services = new Map<string, unknown>();
  private factories = new Map<string, Factory<unknown>>();

  private constructor() {}

  public static getInstance(): DIContainer {
    if (!DIContainer.instance) {
      DIContainer.instance = new DIContainer();
    }
    return DIContainer.instance;
  }

  public registerSingleton<T>(key: string, instance: T): void {
    this.services.set(key, instance);
  }

  public registerFactory<T>(key: string, factory: Factory<T>): void {
    this.factories.set(key, factory as Factory<unknown>);
  }

  public resolve<T>(key: string): T {
    if (this.services.has(key)) {
      return this.services.get(key) as T;
    }

    if (this.factories.has(key)) {
      const factory = this.factories.get(key)!;
      const instance = factory(this) as T;
      this.services.set(key, instance); // Cache factory result as singleton
      return instance;
    }

    throw new Error(`[DIContainer]: Service '${key}' is not registered in the DI container.`);
  }

  public has(key: string): boolean {
    return this.services.has(key) || this.factories.has(key);
  }

  public reset(): void {
    this.services.clear();
    this.factories.clear();
  }
}

export const container = DIContainer.getInstance();
