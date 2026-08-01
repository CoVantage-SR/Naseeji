import { RequestContext } from '../../core/context/request-context.js';

export interface ApiResponse<T = unknown> {
  success: boolean;
  message: string;
  data: T | null;
  errors: unknown[] | null;
  timestamp: string;
  traceId: string;
}

export class ApiResponseBuilder {
  public static success<T>(data: T, message = 'Operation completed successfully'): ApiResponse<T> {
    return {
      success: true,
      message,
      data,
      errors: null,
      timestamp: new Date().toISOString(),
      traceId: RequestContext.getTraceId(),
    };
  }

  public static error(
    message = 'An unexpected error occurred',
    errors: unknown[] | null = null,
  ): ApiResponse<null> {
    return {
      success: false,
      message,
      data: null,
      errors,
      timestamp: new Date().toISOString(),
      traceId: RequestContext.getTraceId(),
    };
  }
}
