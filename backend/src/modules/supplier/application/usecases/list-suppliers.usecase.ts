import {
  SupplierRepository,
  ListSuppliersQuery,
} from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { PublicSupplierDto } from '../dtos/supplier.dto.js';
import { GetSupplierProfileUseCase } from './get-supplier-profile.usecase.js';

export interface PaginatedPublicSuppliersResponse {
  suppliers: PublicSupplierDto[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export class ListSuppliersUseCase {
  constructor(
    private supplierRepo: SupplierRepository,
    private getSupplierProfileUseCase: GetSupplierProfileUseCase,
  ) {}

  public async execute(query: ListSuppliersQuery): Promise<PaginatedPublicSuppliersResponse> {
    const result = await this.supplierRepo.findAll({
      ...query,
      isActive: true, // Only return active suppliers in public marketplace listing
    });

    const suppliers = result.suppliers.map((doc) =>
      this.getSupplierProfileUseCase.mapToPublicDto(doc),
    );

    return {
      suppliers,
      total: result.total,
      page: result.page,
      limit: result.limit,
      totalPages: result.totalPages,
    };
  }
}
