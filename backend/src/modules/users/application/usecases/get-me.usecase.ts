import { UserRepository } from '../../../auth/infrastructure/repositories/user.repository.js';
import { FactoryRepository } from '../../../auth/infrastructure/repositories/factory.repository.js';
import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { WalletRepository } from '../../../auth/infrastructure/repositories/wallet.repository.js';
import { PermissionResolverService } from '../../../auth/authorization/services/permission-resolver.service.js';
import { MongoRoleRepository } from '../../../auth/authorization/data/repositories/mongo-role.repository.js';
import { GetMeResponseDto } from '../dtos/user.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

export class GetMeUseCase {
  constructor(
    private userRepo: UserRepository,
    private factoryRepo: FactoryRepository,
    private supplierRepo: SupplierRepository,
    private walletRepo: WalletRepository,
    private permissionResolver?: PermissionResolverService,
  ) {
    if (!this.permissionResolver) {
      this.permissionResolver = new PermissionResolverService(new MongoRoleRepository());
    }
  }

  public async execute(userId: string): Promise<GetMeResponseDto> {
    const user = await this.userRepo.findById(userId);
    if (!user) {
      throw new NotFoundException('User profile not found');
    }

    let profile: Record<string, unknown> | null = null;
    if (user.role === 'factory') {
      const f = await this.factoryRepo.findByUserId(user._id);
      if (f) {
        const obj = f as unknown as { toObject?: () => Record<string, unknown> };
        profile =
          typeof obj.toObject === 'function'
            ? obj.toObject()
            : (f as unknown as Record<string, unknown>);
      }
    } else if (user.role === 'supplier') {
      const s = await this.supplierRepo.findByUserId(user._id);
      if (s) {
        const obj = s as unknown as { toObject?: () => Record<string, unknown> };
        profile =
          typeof obj.toObject === 'function'
            ? obj.toObject()
            : (s as unknown as Record<string, unknown>);
      }
    }

    const wallet = await this.walletRepo.findByUserId(user._id);
    const permissions = await this.permissionResolver!.resolvePermissionsForRoles([user.role]);

    return {
      id: user._id,
      phone: user.phone,
      email: user.email,
      role: user.role,
      status: user.status,
      isEmailVerified: user.isEmailVerified,
      isPhoneVerified: user.isPhoneVerified,
      factoryId: user.factoryId,
      supplierId: user.supplierId,
      employeeId: user.employeeId,
      walletId: user.walletId,
      profile,
      wallet: wallet
        ? {
            id: wallet._id,
            balance: wallet.balance,
            pointsBalance: wallet.pointsBalance,
            currency: wallet.currency,
          }
        : null,
      permissions,
      createdAt: user.createdAt ? user.createdAt.toISOString() : undefined,
      updatedAt: user.updatedAt ? user.updatedAt.toISOString() : undefined,
    };
  }
}
