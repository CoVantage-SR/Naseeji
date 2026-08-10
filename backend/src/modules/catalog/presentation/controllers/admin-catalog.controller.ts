import { Request, Response, NextFunction } from 'express';
import { AdminProductManagementUseCase } from '../../application/usecases/admin-product-management.usecase.js';
import { GetProductUseCase } from '../../application/usecases/get-product.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

export class AdminCatalogController {
  constructor(
    private adminProductUseCase: AdminProductManagementUseCase,
    private getProductUseCase: GetProductUseCase,
  ) {}

  private extractUserId(req: Request): string {
    const userId = req.userContext?.userId;
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return userId;
  }

  public listProducts = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const page = Number(req.query.page || '1');
      const limit = Number(req.query.limit || '20');

      const filters: Record<string, any> = {};
      if (req.query.status) filters.status = req.query.status;
      if (req.query.supplierId) filters.supplierId = req.query.supplierId;
      if (req.query.search) filters.search = req.query.search;

      const result = await this.adminProductUseCase.listProducts(filters, page, limit);
      res.status(200).json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  };

  public getProductById = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { id } = req.params;
      const data = await this.getProductUseCase.getById(id, false);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public updateProductStatus = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const { id } = req.params;
      const { status, notes } = req.body;

      const data = await this.adminProductUseCase.updateProductStatus(
        id,
        userId,
        status,
        notes,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );

      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };
}
