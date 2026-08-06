import { Request, Response } from 'express';
import { SupplierVerificationUseCase } from '../../application/usecases/supplier-verification.usecase.js';

interface RequestWithUser extends Request {
  user?: {
    userId?: string;
    id?: string;
  };
}

export class VerificationController {
  constructor(private supplierVerificationUseCase: SupplierVerificationUseCase) {}

  public getPendingRequests = async (_req: Request, res: Response): Promise<void> => {
    try {
      const requests = await this.supplierVerificationUseCase.getPendingRequests();
      res.status(200).json({ success: true, data: requests });
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public updateStatus = async (req: Request, res: Response): Promise<void> => {
    try {
      const customReq = req as RequestWithUser;
      const reviewerId =
        req.userContext?.userId || customReq.user?.userId || customReq.user?.id || '';
      const requestId = req.params.requestId ?? '';
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
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };
}
