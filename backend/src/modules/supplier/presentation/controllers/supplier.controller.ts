import { Request, Response, NextFunction } from 'express';
import { GetSupplierProfileUseCase } from '../../application/usecases/get-supplier-profile.usecase.js';
import { UpdateSupplierProfileUseCase } from '../../application/usecases/update-supplier-profile.usecase.js';
import { ListSuppliersUseCase } from '../../application/usecases/list-suppliers.usecase.js';
import { SubmitSupplierVerificationUseCase } from '../../application/usecases/submit-supplier-verification.usecase.js';
import { AdminSupplierManagementUseCase } from '../../application/usecases/admin-supplier-management.usecase.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

export class SupplierController {
  constructor(
    private getSupplierProfileUseCase: GetSupplierProfileUseCase,
    private updateSupplierProfileUseCase: UpdateSupplierProfileUseCase,
    private listSuppliersUseCase: ListSuppliersUseCase,
    private submitSupplierVerificationUseCase: SubmitSupplierVerificationUseCase,
    private adminSupplierManagementUseCase: AdminSupplierManagementUseCase,
  ) {}

  private extractUserId(req: Request): string {
    const userId = req.userContext?.userId;
    if (!userId) {
      throw new AuthenticationException('User context missing');
    }
    return userId;
  }

  public getSelfProfile = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.getSupplierProfileUseCase.getSelfProfile(userId);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public updateSelfProfile = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.updateSupplierProfileUseCase.execute(
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

  public getPublicProfile = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const idOrSlug = req.params.idOrSlug || '';
      const data = await this.getSupplierProfileUseCase.getPublicProfile(idOrSlug);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public listSuppliers = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const query = {
        search: req.query.search as string | undefined,
        category: req.query.category as string | undefined,
        governorate: req.query.governorate as string | undefined,
        city: req.query.city as string | undefined,
        verificationStatus: req.query.verificationStatus as string | undefined,
        isVerified:
          req.query.isVerified !== undefined ? req.query.isVerified === 'true' : undefined,
        page: req.query.page ? parseInt(req.query.page as string, 10) : 1,
        limit: req.query.limit ? parseInt(req.query.limit as string, 10) : 20,
      };
      const result = await this.listSuppliersUseCase.execute(query);
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(err);
    }
  };

  public submitVerification = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.submitSupplierVerificationUseCase.execute(
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

  public adminReviewVerification = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const reviewerId = this.extractUserId(req);
      const requestId = req.params.requestId || '';
      const data = await this.adminSupplierManagementUseCase.reviewVerificationRequest(
        requestId,
        req.body,
        reviewerId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };

  public adminSetSupplierActiveStatus = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const actorUserId = this.extractUserId(req);
      const supplierId = req.params.id || '';
      const data = await this.adminSupplierManagementUseCase.setSupplierActiveStatus(
        supplierId,
        req.body,
        actorUserId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(err);
    }
  };
}
