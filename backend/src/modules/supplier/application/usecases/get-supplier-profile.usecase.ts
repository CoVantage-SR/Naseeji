import { SupplierRepository } from '../../../auth/infrastructure/repositories/supplier.repository.js';
import { PrivateSupplierDto, PublicSupplierDto } from '../dtos/supplier.dto.js';
import { NotFoundException } from '../../../../core/errors/not-found.exception.js';
import { ISupplierDocument } from '../../../auth/infrastructure/database/supplier.schema.js';

export class GetSupplierProfileUseCase {
  constructor(private supplierRepo: SupplierRepository) {}

  public async getSelfProfile(userId: string): Promise<PrivateSupplierDto> {
    const supplier = await this.supplierRepo.findByUserId(userId);
    if (!supplier) {
      throw new NotFoundException('Supplier profile not found');
    }
    return this.mapToPrivateDto(supplier);
  }

  public async getPublicProfile(idOrSlug: string): Promise<PublicSupplierDto> {
    const supplier = await this.supplierRepo.findByIdOrSlug(idOrSlug);
    if (!supplier || !supplier.isActive) {
      throw new NotFoundException('Supplier not found');
    }
    return this.mapToPublicDto(supplier);
  }

  private mapToPrivateDto(doc: ISupplierDocument): PrivateSupplierDto {
    return {
      id: doc._id,
      userId: doc.userId,
      companyName: doc.companyName,
      slug: doc.slug,
      description: doc.description,
      supplierCategory: doc.supplierCategory,
      businessType: doc.businessType,
      logo: doc.logo,
      coverImage: doc.coverImage,
      phone: doc.phone,
      email: doc.email,
      commercialRegistration: doc.commercialRegistration,
      taxNumber: doc.taxNumber,
      governorate: doc.governorate,
      city: doc.city,
      address: doc.address,
      website: doc.website,
      verificationStatus: doc.verificationStatus,
      verificationNotes: doc.verificationNotes,
      verificationLevel: doc.verificationLevel || 'none',
      isVerified: doc.isVerified || false,
      subscriptionStatus: doc.subscriptionStatus,
      rating: doc.rating || 0,
      ratingCount: doc.ratingCount || 0,
      totalProducts: doc.totalProducts || 0,
      totalOrders: doc.totalOrders || 0,
      responseRate: doc.responseRate || 100,
      responseTime: doc.responseTime || 24,
      isActive: doc.isActive !== false,
      createdAt: doc.createdAt ? doc.createdAt.toISOString() : undefined,
    };
  }

  public mapToPublicDto(doc: ISupplierDocument): PublicSupplierDto {
    return {
      id: doc._id,
      companyName: doc.companyName,
      slug: doc.slug,
      description: doc.description,
      supplierCategory: doc.supplierCategory,
      businessType: doc.businessType,
      logo: doc.logo,
      coverImage: doc.coverImage,
      governorate: doc.governorate,
      city: doc.city,
      website: doc.website,
      isVerified: doc.isVerified || false,
      verificationLevel: doc.verificationLevel || 'none',
      rating: doc.rating || 0,
      ratingCount: doc.ratingCount || 0,
      totalProducts: doc.totalProducts || 0,
      totalOrders: doc.totalOrders || 0,
      responseRate: doc.responseRate || 100,
      responseTime: doc.responseTime || 24,
      isActive: doc.isActive !== false,
      createdAt: doc.createdAt ? doc.createdAt.toISOString() : undefined,
    };
  }
}
