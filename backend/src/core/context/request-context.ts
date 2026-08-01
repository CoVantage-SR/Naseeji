import { AsyncLocalStorage } from 'async_hooks';

export interface IRequestContext {
  traceId: string;
  startTime: number;
}

export class RequestContext {
  private static asyncLocalStorage = new AsyncLocalStorage<IRequestContext>();

  public static run(context: IRequestContext, fn: () => void): void {
    this.asyncLocalStorage.run(context, fn);
  }

  public static get(): IRequestContext | undefined {
    return this.asyncLocalStorage.getStore();
  }

  public static getTraceId(): string {
    const store = this.get();
    return store?.traceId || 'system-internal-trace';
  }
}
