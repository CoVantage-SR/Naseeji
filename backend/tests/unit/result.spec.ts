import { Result } from '../../src/core/result/result';

describe('Result Monad Unit Tests', () => {
  it('should create a successful result with value', () => {
    const res = Result.ok({ id: '123' });
    expect(res.isSuccess).toBe(true);
    expect(res.isFailure).toBe(false);
    expect(res.getValue()).toEqual({ id: '123' });
  });

  it('should create a failure result with error message', () => {
    const res = Result.fail('Invalid operation');
    expect(res.isSuccess).toBe(false);
    expect(res.isFailure).toBe(true);
    expect(res.getError()).toBe('Invalid operation');
  });

  it('should throw when trying to access value of a failure result', () => {
    const res = Result.fail('Error occurred');
    expect(() => res.getValue()).toThrow();
  });
});
