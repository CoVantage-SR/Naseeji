import { ProductModel, IProductDocument } from '../database/product.schema.js';

export interface ProductMarketplaceFilter {
  search?: string;
  categoryId?: string;
  subcategoryId?: string;
  brandId?: string;
  supplierId?: string;
  storeId?: string;
  city?: string;
  country?: string;
  productType?: string;
  status?: string;
  visibility?: string;
  priceMin?: number;
  priceMax?: number;
  minimumOrderQuantity?: number;
  isFeatured?: boolean;
  isNegotiable?: boolean;
  allowRFQ?: boolean;
}

export class ProductRepository {
  public async findById(id: string): Promise<IProductDocument | null> {
    return ProductModel.findById(id).lean();
  }

  public async findBySlug(slug: string): Promise<IProductDocument | null> {
    return ProductModel.findOne({ slug }).lean();
  }

  public async findBySku(sku: string): Promise<IProductDocument | null> {
    return ProductModel.findOne({ sku }).lean();
  }

  public async create(data: Partial<IProductDocument>): Promise<IProductDocument> {
    const doc = await ProductModel.create(data);
    return doc.toObject();
  }

  public async update(
    id: string,
    data: Partial<IProductDocument>,
  ): Promise<IProductDocument | null> {
    return ProductModel.findByIdAndUpdate(id, { $set: data }, { new: true }).lean();
  }

  public async delete(id: string): Promise<boolean> {
    const res = await ProductModel.findByIdAndUpdate(id, { $set: { status: 'archived' } });
    return Boolean(res);
  }

  public async listMarketplace(
    filters: ProductMarketplaceFilter = {},
    page = 1,
    limit = 20,
    sortOption = 'newest',
  ): Promise<{ items: IProductDocument[]; total: number }> {
    const skip = (page - 1) * limit;
    const query: Record<string, any> = {
      status: filters.status || 'active',
      visibility: filters.visibility || 'public',
    };

    if (filters.search) {
      query.$text = { $search: filters.search };
    }
    if (filters.categoryId) query.categoryId = filters.categoryId;
    if (filters.subcategoryId) query.subcategoryId = filters.subcategoryId;
    if (filters.brandId) query.brandId = filters.brandId;
    if (filters.supplierId) query.supplierId = filters.supplierId;
    if (filters.storeId) query.storeId = filters.storeId;
    if (filters.city) query.originCity = new RegExp(`^${filters.city}$`, 'i');
    if (filters.country) query.originCountry = new RegExp(`^${filters.country}$`, 'i');
    if (filters.productType) query.productType = filters.productType;
    if (filters.isFeatured !== undefined) query.isFeatured = filters.isFeatured;
    if (filters.isNegotiable !== undefined) query.isNegotiable = filters.isNegotiable;
    if (filters.allowRFQ !== undefined) query.allowRFQ = filters.allowRFQ;

    if (filters.priceMin !== undefined || filters.priceMax !== undefined) {
      query.price = {};
      if (filters.priceMin !== undefined) query.price.$gte = filters.priceMin;
      if (filters.priceMax !== undefined) query.price.$lte = filters.priceMax;
    }

    if (filters.minimumOrderQuantity !== undefined) {
      query.minimumOrderQuantity = { $lte: filters.minimumOrderQuantity };
    }

    let sort: Record<string, any> = { createdAt: -1 };
    if (sortOption === 'price_low') sort = { price: 1 };
    else if (sortOption === 'price_high') sort = { price: -1 };
    else if (sortOption === 'rating') sort = { rating: -1, ratingCount: -1 };
    else if (sortOption === 'popularity') sort = { viewCount: -1, totalOrders: -1 };
    else if (sortOption === 'relevance' && filters.search) {
      sort = { score: { $meta: 'textScore' } };
    }

    const [items, total] = await Promise.all([
      ProductModel.find(query).sort(sort).skip(skip).limit(limit).lean(),
      ProductModel.countDocuments(query),
    ]);

    return { items, total };
  }

  public async listBySupplier(
    supplierId: string,
    filters: { status?: string; search?: string } = {},
    page = 1,
    limit = 20,
  ): Promise<{ items: IProductDocument[]; total: number }> {
    const skip = (page - 1) * limit;
    const query: Record<string, any> = { supplierId };

    if (filters.status) query.status = filters.status;
    else query.status = { $ne: 'archived' };

    if (filters.search) {
      query.$or = [
        { name: { $regex: filters.search, $options: 'i' } },
        { sku: { $regex: filters.search, $options: 'i' } },
      ];
    }

    const [items, total] = await Promise.all([
      ProductModel.find(query).sort({ createdAt: -1 }).skip(skip).limit(limit).lean(),
      ProductModel.countDocuments(query),
    ]);

    return { items, total };
  }

  public async listAdmin(
    filters: Record<string, any> = {},
    page = 1,
    limit = 20,
  ): Promise<{ items: IProductDocument[]; total: number }> {
    const skip = (page - 1) * limit;
    const query: Record<string, any> = {};

    if (filters.status) query.status = filters.status;
    if (filters.supplierId) query.supplierId = filters.supplierId;
    if (filters.search) {
      query.$or = [
        { name: { $regex: filters.search, $options: 'i' } },
        { sku: { $regex: filters.search, $options: 'i' } },
      ];
    }

    const [items, total] = await Promise.all([
      ProductModel.find(query).sort({ createdAt: -1 }).skip(skip).limit(limit).lean(),
      ProductModel.countDocuments(query),
    ]);

    return { items, total };
  }

  public async incrementViewCount(id: string): Promise<void> {
    await ProductModel.findByIdAndUpdate(id, { $inc: { viewCount: 1 } });
  }
}
