import mongoose from 'mongoose';
import { SupplierModel, ISupplierDocument } from '../database/supplier.schema.js';

export interface ListSuppliersQuery {
  search?: string;
  category?: string;
  governorate?: string;
  city?: string;
  verificationStatus?: string;
  isVerified?: boolean;
  isActive?: boolean;
  page?: number;
  limit?: number;
}

export interface PaginatedSuppliersResult {
  suppliers: ISupplierDocument[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export class SupplierRepository {
  public async create(data: Partial<ISupplierDocument>): Promise<ISupplierDocument> {
    if (mongoose.connection.readyState !== 1) return data as ISupplierDocument;
    return await SupplierModel.create(data);
  }

  public async findById(id: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findById(id);
  }

  public async findByUserId(userId: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOne({ userId });
  }

  public async findBySlug(slug: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOne({ slug });
  }

  public async findByIdOrSlug(idOrSlug: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOne({
      $or: [{ _id: idOrSlug }, { slug: idOrSlug }],
    });
  }

  public async findByCommercialRegistration(cr: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOne({ commercialRegistration: cr });
  }

  public async findByTaxNumber(tax: string): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOne({ taxNumber: tax });
  }

  public async findAll(query: ListSuppliersQuery): Promise<PaginatedSuppliersResult> {
    const page = Math.max(1, query.page || 1);
    const limit = Math.min(100, Math.max(1, query.limit || 20));
    const skip = (page - 1) * limit;

    if (mongoose.connection.readyState !== 1) {
      return { suppliers: [], total: 0, page, limit, totalPages: 1 };
    }

    const filter: Record<string, unknown> = {};

    if (query.isActive !== undefined) filter.isActive = query.isActive;
    if (query.isVerified !== undefined) filter.isVerified = query.isVerified;
    if (query.verificationStatus) filter.verificationStatus = query.verificationStatus;
    if (query.category) filter.supplierCategory = query.category;
    if (query.governorate) filter.governorate = query.governorate;
    if (query.city) filter.city = query.city;

    if (query.search) {
      const searchRegex = new RegExp(query.search.trim(), 'i');
      filter.$or = [
        { companyName: searchRegex },
        { description: searchRegex },
        { supplierCategory: searchRegex },
      ];
    }

    const [suppliers, total] = await Promise.all([
      SupplierModel.find(filter).sort({ rating: -1, createdAt: -1 }).skip(skip).limit(limit),
      SupplierModel.countDocuments(filter),
    ]);

    return {
      suppliers,
      total,
      page,
      limit,
      totalPages: Math.ceil(total / limit) || 1,
    };
  }

  public async updateByUserId(
    userId: string,
    updates: Partial<ISupplierDocument>,
  ): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return updates as ISupplierDocument;
    return await SupplierModel.findOneAndUpdate({ userId }, updates, { new: true });
  }

  public async updateVerificationStatus(
    userId: string,
    status: 'verified' | 'rejected' | 'pending' | 'need_more_documents',
    notes?: string,
  ): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    const isVerified = status === 'verified';
    const verificationLevel = isVerified ? 'verified' : 'none';
    return await SupplierModel.findOneAndUpdate(
      { userId },
      {
        verificationStatus: status,
        verificationNotes: notes,
        isVerified,
        verificationLevel,
      },
      { new: true },
    );
  }

  public async updateActiveStatus(
    userId: string,
    isActive: boolean,
  ): Promise<ISupplierDocument | null> {
    if (mongoose.connection.readyState !== 1) return null;
    return await SupplierModel.findOneAndUpdate({ userId }, { isActive }, { new: true });
  }
}
