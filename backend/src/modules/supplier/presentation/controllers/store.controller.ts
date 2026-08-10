import { Request, Response, NextFunction } from 'express';
import { CreateStoreUseCase } from '../../application/usecases/create-store.usecase.js';
import { UpdateStoreUseCase } from '../../application/usecases/update-store.usecase.js';
import { GetStoreUseCase } from '../../application/usecases/get-store.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

export class StoreController {
  constructor(
    private createStoreUseCase: CreateStoreUseCase,
    private updateStoreUseCase: UpdateStoreUseCase,
    private getStoreUseCase: GetStoreUseCase,
  ) {}

  private extractUserId(req: Request): string {
    const userId = req.userContext?.userId;
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return userId;
  }

  public createStore = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.createStoreUseCase.execute(
        userId,
        req.body,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(201).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public getSelfStore = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.getStoreUseCase.getSelfStore(userId);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public updateSelfStore = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.updateStoreUseCase.execute(
        userId,
        req.body,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public getPublicStoreBySlug = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const slug = req.params.slug || '';
      const data = await this.getStoreUseCase.getPublicStoreBySlug(slug);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };
}
