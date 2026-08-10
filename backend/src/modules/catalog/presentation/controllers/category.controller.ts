import { Request, Response, NextFunction } from 'express';
import { CreateCategoryUseCase } from '../../application/usecases/create-category.usecase.js';
import { UpdateCategoryUseCase } from '../../application/usecases/update-category.usecase.js';
import { DeleteCategoryUseCase } from '../../application/usecases/delete-category.usecase.js';
import { GetCategoryUseCase } from '../../application/usecases/get-category.usecase.js';
import { ListCategoriesUseCase } from '../../application/usecases/list-categories.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

export class CategoryController {
  constructor(
    private createCategoryUseCase: CreateCategoryUseCase,
    private updateCategoryUseCase: UpdateCategoryUseCase,
    private deleteCategoryUseCase: DeleteCategoryUseCase,
    private getCategoryUseCase: GetCategoryUseCase,
    private listCategoriesUseCase: ListCategoriesUseCase,
  ) {}

  private extractUserId(req: Request): string {
    const userId = req.userContext?.userId;
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return userId;
  }

  public createCategory = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.createCategoryUseCase.execute(
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

  public updateCategory = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const { id } = req.params;
      const data = await this.updateCategoryUseCase.execute(
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

  public deleteCategory = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const { id } = req.params;
      await this.deleteCategoryUseCase.execute(
        id,
        userId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, message: 'Category deleted successfully' });
    } catch (err) {
      next(err);
    }
  };

  public getCategoryById = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { id } = req.params;
      const data = await this.getCategoryUseCase.getById(id);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public getCategoryBySlug = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { slug } = req.params;
      const data = await this.getCategoryUseCase.getBySlug(slug);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public listCategories = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const page = Number(req.query.page || '1');
      const limit = Number(req.query.limit || '50');
      const tree = req.query.tree === 'true';

      if (tree) {
        const treeData = await this.listCategoriesUseCase.getTree();
        res.status(200).json({ success: true, data: treeData });
        return;
      }

      const filters: Record<string, any> = {};
      if (req.query.status) filters.status = req.query.status;
      if (req.query.parentId) filters.parentId = req.query.parentId;
      if (req.query.isFeatured !== undefined) filters.isFeatured = req.query.isFeatured === 'true';

      const result = await this.listCategoriesUseCase.execute(filters, page, limit);
      res.status(200).json({ success: true, data: result.items, total: result.total, page, limit });
    } catch (err) {
      next(err);
    }
  };

  public getCategoryTree = async (
    _req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const treeData = await this.listCategoriesUseCase.getTree();
      res.status(200).json({ success: true, data: treeData });
    } catch (err) {
      next(err);
    }
  };
}
