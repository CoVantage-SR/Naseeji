import { Request, Response, NextFunction } from 'express';
import { RegisterFactoryUseCase } from '../../application/usecases/register-factory.usecase.js';
import { RegisterSupplierUseCase } from '../../application/usecases/register-supplier.usecase.js';
import { LoginUseCase } from '../../application/usecases/login.usecase.js';
import { LogoutUseCase } from '../../application/usecases/logout.usecase.js';
import { RefreshTokenUseCase } from '../../application/usecases/refresh-token.usecase.js';
import {
  ForgotPasswordUseCase,
  ResetPasswordUseCase,
} from '../../application/usecases/forgot-password.usecase.js';
import { ChangePasswordUseCase } from '../../application/usecases/change-password.usecase.js';
import { VerifyEmailPhoneUseCase } from '../../application/usecases/verify-email-phone.usecase.js';
import { SessionManagementUseCase } from '../../application/usecases/session-management.usecase.js';
import { AccountLifecycleUseCase } from '../../application/usecases/account-lifecycle.usecase.js';
import { GoogleLoginUseCase } from '../../application/usecases/google-login.usecase.js';
import { DeviceManagementUseCase } from '../../application/usecases/device-management.usecase.js';
import { WhatsAppOtpProvider } from '../../infrastructure/providers/whatsapp-otp.provider.js';
import { UserRepository } from '../../infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../infrastructure/repositories/supplier.repository.js';
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';
import { BusinessException } from '../../../../core/errors/business.exception.js';
import { AuthenticationException } from '../../../../core/errors/auth.exception.js';

/** Fields that must never be changed by a user through the profile update endpoint */
const PROTECTED_PROFILE_FIELDS = [
  'verificationStatus',
  'subscriptionStatus',
  'userId',
  '_id',
  'id',
  'commercialRegistration',
  'taxNumber',
] as const;

export class EnterpriseAuthController {
  constructor(
    private registerFactoryUseCase: RegisterFactoryUseCase,
    private registerSupplierUseCase: RegisterSupplierUseCase,
    private loginUseCase: LoginUseCase,
    private logoutUseCase: LogoutUseCase,
    private refreshTokenUseCase: RefreshTokenUseCase,
    private forgotPasswordUseCase: ForgotPasswordUseCase,
    private resetPasswordUseCase: ResetPasswordUseCase,
    private changePasswordUseCase: ChangePasswordUseCase,
    private verifyEmailPhoneUseCase: VerifyEmailPhoneUseCase,
    private sessionManagementUseCase: SessionManagementUseCase,
    private accountLifecycleUseCase: AccountLifecycleUseCase,
    private googleLoginUseCase: GoogleLoginUseCase,
    private deviceManagementUseCase: DeviceManagementUseCase,
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private supplierRepo: SupplierRepository,
    private securityLogRepo: SecurityLogRepository,
  ) {}

  private extractUserId(req: Request): string {
    return req.userContext?.userId || '';
  }

  private sanitizeProfileUpdate(body: Record<string, unknown>): Record<string, unknown> {
    const sanitized = { ...body };
    for (const field of PROTECTED_PROFILE_FIELDS) {
      delete sanitized[field];
    }
    return sanitized;
  }

  // ─── Registration ───────────────────────────────────────────────────────────

  public registerFactory = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const result = await this.registerFactoryUseCase.execute({
        ...req.body,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(201).json({ success: true, data: result });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public registerSupplier = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const result = await this.registerSupplierUseCase.execute({
        ...req.body,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(201).json({ success: true, data: result });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  // ─── Login ──────────────────────────────────────────────────────────────────

  public login = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const result = await this.loginUseCase.execute({
        ...req.body,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(new AuthenticationException((err as Error).message));
    }
  };

  public loginGoogle = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const result = await this.googleLoginUseCase.execute({
        idToken: req.body.idToken,
        accountType: req.body.accountType,
        deviceInfo: {
          userId: '',
          deviceId: req.body.deviceId || 'device-id-unknown',
          deviceName: req.body.deviceName || 'Mobile Device',
          deviceType: req.body.deviceType || 'android',
          osVersion: req.body.osVersion || '14.0',
          appVersion: req.body.appVersion || '1.0.0',
          ipAddress: req.ip || '127.0.0.1',
          country: req.body.country,
          city: req.body.city,
          pushToken: req.body.pushToken,
          firebaseInstallationId: req.body.firebaseInstallationId,
        },
      });
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(new AuthenticationException((err as Error).message));
    }
  };

  // ─── OTP ───────────────────────────────────────────────────────────────────

  public sendWhatsAppOtp = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { phone, type } = req.body;
      const result = await WhatsAppOtpProvider.getInstance().generateAndSendOtp({
        phone,
        type: type || 'phone_verification',
      });
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public verifyWhatsAppOtp = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { phone, type, otpCode } = req.body;
      await WhatsAppOtpProvider.getInstance().verifyOtp(
        phone,
        type || 'phone_verification',
        otpCode,
      );

      // If the user is authenticated, mark phone as verified
      const userId = this.extractUserId(req);
      if (userId) {
        await this.userRepo.update(userId, { isPhoneVerified: true });
      }

      res.status(200).json({
        success: true,
        message: 'WhatsApp OTP code verified successfully.',
      });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  // ─── Token ─────────────────────────────────────────────────────────────────

  public refreshToken = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const { refreshToken } = req.body;
      const result = await this.refreshTokenUseCase.execute({
        refreshToken,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json({ success: true, data: result });
    } catch (err) {
      next(new AuthenticationException((err as Error).message));
    }
  };

  // ─── Logout ─────────────────────────────────────────────────────────────────

  public logout = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const { refreshToken } = req.body;
      const result = await this.logoutUseCase.execute(
        userId,
        refreshToken,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json({ success: true, message: result.message });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  // ─── Password ───────────────────────────────────────────────────────────────

  public forgotPassword = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const result = await this.forgotPasswordUseCase.execute({
        target: req.body.target,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public resetPassword = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const result = await this.resetPasswordUseCase.execute({
        ...req.body,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public changePassword = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const result = await this.changePasswordUseCase.execute({
        userId,
        oldPassword: req.body.oldPassword,
        newPassword: req.body.newPassword,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  // ─── OTP Verification ───────────────────────────────────────────────────────

  public verifyPhone = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const { phone, otpCode } = req.body;
      const result = await this.verifyEmailPhoneUseCase.verifyPhone(
        userId,
        phone,
        otpCode,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public verifyEmail = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const { email, otpCode } = req.body;
      const result = await this.verifyEmailPhoneUseCase.verifyEmail(
        userId,
        email,
        otpCode,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public resendOtp = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const { target, type } = req.body;
      const result = await this.verifyEmailPhoneUseCase.resendOtp(
        target,
        type,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  // ─── Account Lifecycle ──────────────────────────────────────────────────────

  public deactivate = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const result = await this.accountLifecycleUseCase.deactivate(
        userId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public softDelete = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const result = await this.accountLifecycleUseCase.softDelete(
        userId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  // ─── Session Management ─────────────────────────────────────────────────────

  public getSessions = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const sessions = await this.sessionManagementUseCase.getActiveSessions(userId);
      res.status(200).json({ success: true, data: sessions });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public revokeSession = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const sessionId = req.params.sessionId ?? '';
      const result = await this.sessionManagementUseCase.revokeSession(
        userId,
        sessionId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public revokeAllSessions = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const result = await this.sessionManagementUseCase.revokeAllSessions(
        userId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  // ─── Device Management ──────────────────────────────────────────────────────

  public getDevices = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const devices = await this.deviceManagementUseCase.getUserDevices(userId);
      res.status(200).json({ success: true, data: devices });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public deleteDevice = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const deviceId = req.params.id ?? '';
      const result = await this.deviceManagementUseCase.removeDevice(
        userId,
        deviceId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  // ─── Profile & Security Logs ────────────────────────────────────────────────

  public getMe = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.deviceManagementUseCase.getMe(userId);
      res.status(200).json({ success: true, data });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public updateProfile = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const user = await this.userRepo.findById(userId);
      if (!user) {
        res.status(404).json({ success: false, message: 'User not found' });
        return;
      }

      // Strip any protected fields from the update payload
      const safeUpdate = this.sanitizeProfileUpdate(req.body as Record<string, unknown>);

      let profile: unknown = null;
      if (user.role === 'factory') {
        profile = await this.factoryRepo.updateByUserId(userId, safeUpdate);
      } else if (user.role === 'supplier') {
        profile = await this.supplierRepo.updateByUserId(userId, safeUpdate);
      }

      res.status(200).json({ success: true, data: profile });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };

  public getSecurityLogs = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const logs = await this.securityLogRepo.findByUserId(userId, 50);
      res.status(200).json({ success: true, data: logs });
    } catch (err) {
      next(new BusinessException((err as Error).message));
    }
  };
}
