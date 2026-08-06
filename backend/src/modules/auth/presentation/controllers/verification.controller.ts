import { Request, Response, NextFunction } from 'express';
import { SupplierVerificationUseCase } from '../../application/usecases/supplier-verification.usecase.js';

export class VerificationController {
  constructor(private supplierVerificationUseCase: SupplierVerificationUseCase) {}

  public getPendingRequests = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const requests = await this.supplierVerificationUseCase.getPendingRequests();
      res.status(200).json({ success: true, data: requests });
    } catch (err: any) {
      res.status(400).json({ success: false, message: err.message });
    }
  };

  public updateStatus = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const reviewerId = (req.userContext || (req as any).user).userId;
      const { requestId } = req.params;
      const { status, notes } = req.body;

      const result = await this.supplierVerificationUseCase.updateStatus({
        requestId,
        status,
        reviewerId,
        notes,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });

      res.status(200).json({ success: true, data: result });
    } catch (err: any) {
      res.status(400).json({ success: false, message: err.message });
    }
  };
}
