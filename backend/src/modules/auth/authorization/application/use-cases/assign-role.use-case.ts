import { IUserRepository } from '../../../identity/domain/repositories/user.repository.interface.js';
import { IRoleRepository } from '../../domain/repositories/role.repository.interface.js';
import { RoleNotFoundException } from '../../../domain/errors/auth-domain.exceptions.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';

export interface AssignRoleCommand {
  userId: string;
  roleCode: string;
}

export class AssignRoleUseCase {
  constructor(
    private userRepo: IUserRepository,
    private roleRepo: IRoleRepository,
  ) {}

  public async execute(command: AssignRoleCommand): Promise<void> {
    const user = await this.userRepo.findById(command.userId);
    if (!user) {
      throw new NotFoundException(`User with ID ${command.userId} not found`);
    }

    const role = await this.roleRepo.findByCode(command.roleCode);
    if (!role) {
      throw new RoleNotFoundException(`Role "${command.roleCode}" not found`);
    }

    user.assignRole(role.code);
    await this.userRepo.save(user);
  }
}
