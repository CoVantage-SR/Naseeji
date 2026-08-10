import { Request, Response, NextFunction } from 'express';
import { CreateProductUseCase } from '../../application/usecases/create-product.usecase.js';
import { UpdateProductUseCase } from '../../application/usecases/update-product.usecase.js';
import { DeleteProductUseCase } from '../../application/usecases/delete-product.usecase.js';
import { GetProductUseCase } from '../../application/usecases/get-product.usecase.js';
import { ListMarketplaceProductsUseCase } from '../../application/usecases/list-marketplace-products.usecase.js';
import { ListSupplierProductsUseCase } from '../../application/usecases/list-supplier-products.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

export class ProductController {
  constructor(
    private createProductUseCase: CreateProductUseCase,
    private updateProductUseCase: UpdateProductUseCase,
    private deleteProductUseCase: DeleteProductUseCase,
    private getProductUseCase: GetProductUseCase,
    private listMarketplaceProductsUseCase: ListMarketplaceProductsUseCase,
    private listSupplierProductsUseCase: ListSupplierProductsUseCase,
  ) {}

  private extractUserContext(req: Request) {
    const userId = req.userContext?.userId;
    const role = req.userContext?.role || req.userContext?.accountType || 'user';
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return { userId, role };
  }

  public createProduct = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { userId } = this.extractUserContext(req);
      const data = await this.createProductUseCase.execute(
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

  public updateProduct = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { userId, role } = this.extractUserContext(req);
      const { id } = req.params;
      const data = await this.updateProductUseCase.execute(
        id,
        userId,
        role,
        req.body,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public deleteProduct = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { userId, role } = this.extractUserContext(req);
      const { id } = req.params;
      await this.deleteProductUseCase.execute(
        id,
        userId,
        role,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, message: 'Product archived successfully' });
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
      const data = await this.getProductUseCase.getById(id, true);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public getProductBySlug = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { slug } = req.params;
      const data = await this.getProductUseCase.getBySlug(slug);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public listMarketplaceProducts = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const page = Number(req.query.page || '1');
      const limit = Number(req.query.limit || '20');
      const sort = String(req.query.sort || 'newest');

      const filters = {
        search: req.query.search ? String(req.query.search) : undefined,
        categoryId: req.query.category ? String(req.query.category) : undefined,
        subcategoryId: req.query.subcategory ? String(req.query.subcategory) : undefined,
        brandId: req.query.brand ? String(req.query.brand) : undefined,
        supplierId: req.query.supplier ? String(req.query.supplier) : undefined,
        storeId: req.query.store ? String(req.query.store) : undefined,
        city: req.query.city ? String(req.query.city) : undefined,
        country: req.query.country ? String(req.query.country) : undefined,
        productType: req.query.productType ? String(req.query.productType) : undefined,
        status: req.query.status ? String(req.query.status) : 'active',
        priceMin: req.query.priceMin ? Number(req.query.priceMin) : undefined,
        priceMax: req.query.priceMax ? Number(req.query.priceMax) : undefined,
        minimumOrderQuantity: req.query.minimumOrderQuantity
          ? Number(req.query.minimumOrderQuantity)
          : undefined,
        isFeatured: req.query.featured !== undefined ? req.query.featured === 'true' : undefined,
        isNegotiable:
          req.query.negotiable !== undefined ? req.query.negotiable === 'true' : undefined,
        allowRFQ: req.query.allowRFQ !== undefined ? req.query.allowRFQ === 'true' : undefined,
      };

      const result = await this.listMarketplaceProductsUseCase.execute(filters, page, limit, sort);
      res.status(200).json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  };

  public listSelfSupplierProducts = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { userId } = this.extractUserContext(req);
      const page = Number(req.query.page || '1');
      const limit = Number(req.query.limit || '20');

      const filters = {
        status: req.query.status ? String(req.query.status) : undefined,
        search: req.query.search ? String(req.query.search) : undefined,
      };

      const result = await this.listSupplierProductsUseCase.execute(
        userId,
        filters,
        page,
        limit,
      );
      res.status(200).json({ success: true, ...result });
    } catch (err) {
      next(err);
    }
  };
}
