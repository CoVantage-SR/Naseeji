import { Request, Response } from 'express';
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
import { SecurityLogRepository } from '../../infrastructure/repositories/security-log.repository.js';

interface RequestWithUser extends Request {
  user?: {
    userId?: string;
    id?: string;
  };
}

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
    private securityLogRepo: SecurityLogRepository,
  ) {}

  private extractUserId(req: Request): string {
    const customReq = req as RequestWithUser;
    return req.userContext?.userId || customReq.user?.userId || customReq.user?.id || '';
  }

  public registerFactory = async (req: Request, res: Response): Promise<void> => {
    try {
      const result = await this.registerFactoryUseCase.execute({
        ...req.body,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(201).json({ success: true, data: result });
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public registerSupplier = async (req: Request, res: Response): Promise<void> => {
    try {
      const result = await this.registerSupplierUseCase.execute({
        ...req.body,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(201).json({ success: true, data: result });
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public login = async (req: Request, res: Response): Promise<void> => {
    try {
      const result = await this.loginUseCase.execute({
        ...req.body,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json({ success: true, data: result });
    } catch (err: unknown) {
      res.status(401).json({ success: false, message: (err as Error).message });
    }
  };

  public loginGoogle = async (req: Request, res: Response): Promise<void> => {
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
    } catch (err: unknown) {
      res.status(401).json({ success: false, message: (err as Error).message });
    }
  };

  public sendWhatsAppOtp = async (req: Request, res: Response): Promise<void> => {
    try {
      const { phone, type } = req.body;
      const result = await WhatsAppOtpProvider.getInstance().generateAndSendOtp({
        phone,
        type: type || 'phone_verification',
      });
      res.status(200).json(result);
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public verifyWhatsAppOtp = async (req: Request, res: Response): Promise<void> => {
    try {
      const { phone, type, otpCode } = req.body;
      await WhatsAppOtpProvider.getInstance().verifyOtp(
        phone,
        type || 'phone_verification',
        otpCode,
      );

      const userId = this.extractUserId(req);
      if (userId) {
        await this.userRepo.update(userId, { isPhoneVerified: true });
      }

      res.status(200).json({
        success: true,
        message: 'WhatsApp OTP code verified successfully.',
      });
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public logout = async (req: Request, res: Response): Promise<void> => {
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
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public refreshToken = async (req: Request, res: Response): Promise<void> => {
    try {
      const { refreshToken } = req.body;
      const result = await this.refreshTokenUseCase.execute({
        refreshToken,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json({ success: true, data: result });
    } catch (err: unknown) {
      res.status(401).json({ success: false, message: (err as Error).message });
    }
  };

  public forgotPassword = async (req: Request, res: Response): Promise<void> => {
    try {
      const result = await this.forgotPasswordUseCase.execute({
        target: req.body.target,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json(result);
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public resetPassword = async (req: Request, res: Response): Promise<void> => {
    try {
      const result = await this.resetPasswordUseCase.execute({
        ...req.body,
        ipAddress: req.ip || '127.0.0.1',
        userAgent: req.headers['user-agent'] || 'Unknown',
      });
      res.status(200).json(result);
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public changePassword = async (req: Request, res: Response): Promise<void> => {
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
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public verifyPhone = async (req: Request, res: Response): Promise<void> => {
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
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public verifyEmail = async (req: Request, res: Response): Promise<void> => {
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
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public resendOtp = async (req: Request, res: Response): Promise<void> => {
    try {
      const { target, type } = req.body;
      const result = await this.verifyEmailPhoneUseCase.resendOtp(
        target,
        type,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public deactivate = async (req: Request, res: Response): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const result = await this.accountLifecycleUseCase.deactivate(
        userId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public softDelete = async (req: Request, res: Response): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const result = await this.accountLifecycleUseCase.softDelete(
        userId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public getSessions = async (req: Request, res: Response): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const sessions = await this.sessionManagementUseCase.getActiveSessions(userId);
      res.status(200).json({ success: true, data: sessions });
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public getDevices = async (req: Request, res: Response): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const devices = await this.deviceManagementUseCase.getUserDevices(userId);
      res.status(200).json({ success: true, data: devices });
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public deleteDevice = async (req: Request, res: Response): Promise<void> => {
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
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public revokeSession = async (req: Request, res: Response): Promise<void> => {
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
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public revokeAllSessions = async (req: Request, res: Response): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const result = await this.sessionManagementUseCase.revokeAllSessions(
        userId,
        req.ip || '127.0.0.1',
        req.headers['user-agent'] || 'Unknown',
      );
      res.status(200).json(result);
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public getSecurityLogs = async (req: Request, res: Response): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const logs = await this.securityLogRepo.findByUserId(userId, 50);
      res.status(200).json({ success: true, data: logs });
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };

  public getMe = async (req: Request, res: Response): Promise<void> => {
    try {
      const userId = this.extractUserId(req);
      const data = await this.deviceManagementUseCase.getMe(userId);
      res.status(200).json({ success: true, data });
    } catch (err: unknown) {
      res.status(400).json({ success: false, message: (err as Error).message });
    }
  };
}
