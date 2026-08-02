import { Request, Response, NextFunction } from 'express';
import { RegisterUserUseCase } from '../../application/use-cases/register-user.use-case.js';
import { LoginUseCase } from '../../application/use-cases/login.use-case.js';
import { VerifyDeviceLoginUseCase } from '../../application/use-cases/verify-device-login.use-case.js';
import { GenerateOtpUseCase } from '../../otp/application/use-cases/generate-otp.use-case.js';
import { VerifyOtpUseCase } from '../../otp/application/use-cases/verify-otp.use-case.js';
import { ForgotPasswordUseCase } from '../../application/use-cases/forgot-password.use-case.js';
import { ResetPasswordUseCase } from '../../application/use-cases/reset-password.use-case.js';
import { IssueRefreshTokenUseCase } from '../../security/application/use-cases/issue-refresh-token.use-case.js';
import { LogoutUseCase } from '../../application/use-cases/logout.use-case.js';
import { LogoutAllDevicesUseCase } from '../../application/use-cases/logout-all-devices.use-case.js';
import { HttpStatus } from '@core/constants/http-status.constant.js';

export class AuthController {
  constructor(
    private registerUserUseCase: RegisterUserUseCase,
    private loginUseCase: LoginUseCase,
    private verifyDeviceLoginUseCase: VerifyDeviceLoginUseCase,
    private generateOtpUseCase: GenerateOtpUseCase,
    private verifyOtpUseCase: VerifyOtpUseCase,
    private forgotPasswordUseCase: ForgotPasswordUseCase,
    private resetPasswordUseCase: ResetPasswordUseCase,
    private issueRefreshTokenUseCase: IssueRefreshTokenUseCase,
    private logoutUseCase: LogoutUseCase,
    private logoutAllDevicesUseCase: LogoutAllDevicesUseCase,
  ) {}

  public register = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      const result = await this.registerUserUseCase.execute({
        ...req.body,
        ipAddress,
        userAgent,
      });

      res.success(
        {
          user: {
            id: result.user.id,
            phone: result.user.phone.value,
            email: result.user.email,
            status: result.user.status,
            accountType: result.user.accountType,
            profile: result.user.profile,
            roles: result.user.roles,
          },
          company: {
            id: result.company.id,
            name: result.company.name,
            type: result.company.type,
            registrationNumber: result.company.registrationNumber,
          },
          tokens: result.tokens,
        },
        'Registration completed successfully',
        HttpStatus.CREATED,
      );
    } catch (error) {
      next(error);
    }
  };

  public login = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      const result = await this.loginUseCase.execute({
        ...req.body,
        ipAddress,
        userAgent,
      });

      if (result.requireOtpChallenge) {
        res.success(
          {
            requireOtpChallenge: true,
            challengeToken: result.challengeToken,
            user: {
              id: result.user.id,
              phone: result.user.phone.value,
            },
          },
          'Untrusted device detected. OTP challenge required.',
          HttpStatus.OK,
        );
        return;
      }

      res.success(
        {
          user: {
            id: result.user.id,
            phone: result.user.phone.value,
            email: result.user.email,
            status: result.user.status,
            accountType: result.user.accountType,
            profile: result.user.profile,
            roles: result.user.roles,
          },
          tokens: result.tokens,
        },
        'Login successful',
        HttpStatus.OK,
      );
    } catch (error) {
      next(error);
    }
  };

  public verifyDeviceLogin = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      const result = await this.verifyDeviceLoginUseCase.execute({
        ...req.body,
        ipAddress,
        userAgent,
      });

      res.success(
        {
          user: {
            id: result.user.id,
            phone: result.user.phone.value,
            email: result.user.email,
            status: result.user.status,
            accountType: result.user.accountType,
            roles: result.user.roles,
          },
          tokens: result.tokens,
        },
        'Device verified and login successful',
        HttpStatus.OK,
      );
    } catch (error) {
      next(error);
    }
  };

  public generateOtp = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const otp = await this.generateOtpUseCase.execute({ phone: req.body.phone });
      res.success(
        { challengeToken: otp.id, expiresAt: otp.expiresAt },
        'OTP code generated and sent',
        HttpStatus.OK,
      );
    } catch (error) {
      next(error);
    }
  };

  public verifyOtp = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const isValid = await this.verifyOtpUseCase.execute({
        phone: req.body.phone,
        code: req.body.code,
      });
      res.success({ verified: isValid }, 'OTP verified successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };

  public forgotPassword = async (
    req: Request,
    res: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      const otp = await this.forgotPasswordUseCase.execute({
        phone: req.body.phone,
        ipAddress,
        userAgent,
      });
      res.success(
        { challengeToken: otp.id, expiresAt: otp.expiresAt },
        'Password reset OTP sent to your phone',
        HttpStatus.OK,
      );
    } catch (error) {
      next(error);
    }
  };

  public resetPassword = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      await this.resetPasswordUseCase.execute({
        ...req.body,
        ipAddress,
        userAgent,
      });
      res.success(
        null,
        'Password reset successfully. All previous sessions invalidated. Please login.',
        HttpStatus.OK,
      );
    } catch (error) {
      next(error);
    }
  };

  public refreshToken = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const tokens = await this.issueRefreshTokenUseCase.execute({
        refreshToken: req.body.refreshToken,
      });
      res.success(tokens, 'Token rotated successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };

  public logout = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      await this.logoutUseCase.execute({
        sessionId: req.userContext!.sessionId,
        userId: req.userContext!.userId,
        ipAddress,
        userAgent,
      });
      res.success(null, 'Logged out successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };

  public logoutAll = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const ipAddress = req.ip || '127.0.0.1';
      const userAgent = req.headers['user-agent'] || 'Unknown';
      await this.logoutAllDevicesUseCase.execute({
        userId: req.userContext!.userId,
        ipAddress,
        userAgent,
      });
      res.success(null, 'Logged out from all devices successfully', HttpStatus.OK);
    } catch (error) {
      next(error);
    }
  };
}
