import { Request, Response, NextFunction } from 'express';
import { CreateBrandUseCase } from '../../application/usecases/create-brand.usecase.js';
import { UpdateBrandUseCase } from '../../application/usecases/update-brand.usecase.js';
import { DeleteBrandUseCase } from '../../application/usecases/delete-brand.usecase.js';
import { GetBrandUseCase } from '../../application/usecases/get-brand.usecase.js';
import { ListBrandsUseCase } from '../../application/usecases/list-brands.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

export class BrandController {
  constructor(
    private createBrandUseCase: CreateBrandUseCase,
    private updateBrandUseCase: UpdateBrandUseCase,
    private deleteBrandUseCase: DeleteBrandUseCase,
    private getBrandUseCase: GetBrandUseCase,
    private listBrandsUseCase: ListBrandsUseCase,
  ) {}

  private extractUserId(req: Request): string {
    const userId = req.userContext?.userId;
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return userId;
  }

  public createBrand = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.createBrandUseCase.execute(
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

  public updateBrand = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const { id } = req.params;
      const data = await this.updateBrandUseCase.execute(
        id,
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

  public deleteBrand = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const { id } = req.params;
      await this.deleteBrandUseCase.execute(
        id,
        userId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, message: 'Brand deleted successfully' });
    } catch (err) {
      next(err);
    }
  };

  public getBrandById = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { id } = req.params;
      const data = await this.getBrandUseCase.getById(id);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public getBrandBySlug = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { slug } = req.params;
      const data = await this.getBrandUseCase.getBySlug(slug);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public listBrands = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const page = Number(req.query.page || '1');
      const limit = Number(req.query.limit || '50');

      const filters: Record<string, any> = {};
      if (req.query.status) filters.status = req.query.status;
      if (req.query.search) filters.name = { $regex: req.query.search, $options: 'i' };

      const result = await this.listBrandsUseCase.execute(filters, page, limit);
      res.status(200).json({ success: true, data: result.items, total: result.total, page, limit });
    } catch (err) {
      next(err);
    }
  };
}
