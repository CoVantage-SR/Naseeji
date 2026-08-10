import { Request, Response, NextFunction } from 'express';
import { AddProductMediaUseCase } from '../../application/usecases/add-product-media.usecase.js';
import { DeleteProductMediaUseCase } from '../../application/usecases/delete-product-media.usecase.js';
import { ReorderProductMediaUseCase } from '../../application/usecases/reorder-product-media.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

export class ProductMediaController {
  constructor(
    private addMediaUseCase: AddProductMediaUseCase,
    private deleteMediaUseCase: DeleteProductMediaUseCase,
    private reorderMediaUseCase: ReorderProductMediaUseCase,
  ) {}

  private extractUserContext(req: Request) {
    const userId = req.userContext?.userId;
    const role = req.userContext?.role || req.userContext?.accountType || 'user';
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return { userId, role };
  }

  public addMedia = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { userId, role } = this.extractUserContext(req);
      const data = await this.addMediaUseCase.execute(
        userId,
        role,
        req.body,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(201).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public deleteMedia = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { userId, role } = this.extractUserContext(req);
      const { id } = req.params;
      await this.deleteMediaUseCase.execute(
        id,
        userId,
        role,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, message: 'Media deleted successfully' });
    } catch (err) {
      next(err);
    }
  };

  public reorderMedia = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { userId, role } = this.extractUserContext(req);
      await this.reorderMediaUseCase.execute(userId, role, req.body);
      res.status(200).json({ success: true, message: 'Media reordered successfully' });
    } catch (err) {
      next(err);
    }
  };
}
