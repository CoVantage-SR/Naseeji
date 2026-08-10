/* eslint-disable no-console */
import crypto from 'crypto';
import bcrypt from 'bcrypt';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import path from 'path';
import { UserModel } from '../../modules/auth/infrastructure/database/user.schema.js';
import { FactoryModel } from '../../modules/auth/infrastructure/database/factory.schema.js';
import { SupplierModel } from '../../modules/auth/infrastructure/database/supplier.schema.js';
import { StoreModel } from '../../modules/supplier/infrastructure/database/store.schema.js';
import { WalletModel } from '../../modules/auth/infrastructure/database/wallet.schema.js';
import { RoleModel } from '../../modules/auth/infrastructure/database/role.schema.js';
import { PermissionModel } from '../../modules/auth/infrastructure/database/permission.schema.js';
import { CategoryModel } from '../../modules/catalog/infrastructure/database/category.schema.js';
import { BrandModel } from '../../modules/catalog/infrastructure/database/brand.schema.js';
import { ProductModel } from '../../modules/catalog/infrastructure/database/product.schema.js';
import { ProductMediaModel } from '../../modules/catalog/infrastructure/database/product-media.schema.js';
import { PERMISSIONS_CATALOG, DEFAULT_ROLE_PERMISSIONS } from '../../config/permissions.config.js';

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const primaryUri =
  process.env.MONGODB_URI || 'mongodb://admin:admin123@127.0.0.1:27017/naseeji?authSource=admin';
const fallbackUri = 'mongodb://127.0.0.1:27017/naseeji';

export const seedDatabase = async (): Promise<void> => {
  console.log('🌱 Connecting to MongoDB for Database Seeding...');

  try {
    await mongoose.connect(primaryUri);
  } catch (err: unknown) {
    if (primaryUri.includes('@')) {
      console.log(
        `⚠️ Authenticated connection failed. Trying local unauthenticated URI: ${fallbackUri}`,
      );
      await mongoose.connect(fallbackUri);
    } else {
      throw err;
    }
  }

  // 1. Seed System Permissions (Idempotent)
  console.log('🔒 Seeding System Permissions...');
  await PermissionModel.collection.dropIndexes().catch(() => {});
  await RoleModel.collection.dropIndexes().catch(() => {});
  let permCount = 0;
  for (const perm of PERMISSIONS_CATALOG) {
    const existing = await PermissionModel.findOne({ code: perm.code });
    if (!existing) {
      await PermissionModel.create({
        _id: crypto.randomUUID(),
        code: perm.code,
        group: perm.group,
        description: perm.description,
      });
      permCount++;
    }
  }
  console.log(
    `✅ Seeded ${permCount} new permissions (${PERMISSIONS_CATALOG.length} total active).`,
  );

  // 2. Seed System Roles (Idempotent)
  console.log('🛡️ Seeding System Roles...');
  const systemRoles = [
    {
      code: 'ADMIN',
      name: 'Administrator',
      description: 'Full administrative access across all system resources',
      permissions: DEFAULT_ROLE_PERMISSIONS.ADMIN,
    },
    {
      code: 'admin',
      name: 'Administrator (alias)',
      description: 'Full administrative access across all system resources',
      permissions: DEFAULT_ROLE_PERMISSIONS.admin,
    },
    {
      code: 'FACTORY',
      name: 'Factory Owner',
      description: 'Factory organization management and procurement access',
      permissions: DEFAULT_ROLE_PERMISSIONS.FACTORY,
    },
    {
      code: 'factory',
      name: 'Factory Owner (alias)',
      description: 'Factory organization management and procurement access',
      permissions: DEFAULT_ROLE_PERMISSIONS.factory,
    },
    {
      code: 'SUPPLIER',
      name: 'Supplier Owner',
      description: 'Supplier organization management and product catalog access',
      permissions: DEFAULT_ROLE_PERMISSIONS.SUPPLIER,
    },
    {
      code: 'supplier',
      name: 'Supplier Owner (alias)',
      description: 'Supplier organization management and product catalog access',
      permissions: DEFAULT_ROLE_PERMISSIONS.supplier,
    },
    {
      code: 'EMPLOYEE',
      name: 'Organization Employee',
      description: 'Base access for factory/supplier organization staff',
      permissions: DEFAULT_ROLE_PERMISSIONS.EMPLOYEE,
    },
    {
      code: 'employee',
      name: 'Organization Employee (alias)',
      description: 'Base access for factory/supplier organization staff',
      permissions: DEFAULT_ROLE_PERMISSIONS.employee,
    },
  ];

  let roleCount = 0;
  for (const sysRole of systemRoles) {
    const existing = await RoleModel.findOne({ code: sysRole.code });
    if (!existing) {
      await RoleModel.create({
        _id: crypto.randomUUID(),
        code: sysRole.code,
        name: sysRole.name,
        description: sysRole.description,
        isSystemRole: true,
        permissionCodes: sysRole.permissions,
        permissions: sysRole.permissions,
      });
      roleCount++;
    } else {
      await RoleModel.updateOne(
        { _id: existing._id },
        {
          isSystemRole: true,
          permissionCodes: sysRole.permissions,
          permissions: sysRole.permissions,
        },
      );
    }
  }
  console.log(`✅ Seeded ${roleCount} new system roles.`);

  // 3. Seed Default System Users
  const defaultPasswordHash = await bcrypt.hash('Password@123', 12);

  // 3a. Factory User
  let factoryUser = await UserModel.findOne({ email: 'factory@naseeji.com' });
  if (!factoryUser) {
    const factoryUserId = crypto.randomUUID();
    factoryUser = await UserModel.create({
      _id: factoryUserId,
      email: 'factory@naseeji.com',
      phone: '+201000000001',
      passwordHash: defaultPasswordHash,
      role: 'factory',
      status: 'active',
      isEmailVerified: true,
      isPhoneVerified: true,
    });

    await FactoryModel.create({
      _id: crypto.randomUUID(),
      userId: factoryUserId,
      companyName: 'Naseeji Premier Apparel Factory',
      factoryType: 'apparel',
      governorate: 'Cairo',
      city: 'Cairo',
      address: 'Industrial Zone, Block 4, Cairo',
      commercialRegistration: 'CR-100200300',
      taxNumber: 'TAX-900800700',
      verificationStatus: 'verified',
    });

    await WalletModel.create({
      _id: crypto.randomUUID(),
      userId: factoryUserId,
      balance: 5000,
      pointsBalance: 500,
      currency: 'EGP',
    });

    console.log('✅ Factory User Seeded (email: factory@naseeji.com / pass: Password@123)');
  } else {
    console.log('ℹ️ Factory User already exists.');
  }

  // 3b. Verified Supplier User & Store
  let supplierUser = await UserModel.findOne({ email: 'supplier@naseeji.com' });
  let supplierId: string;
  if (!supplierUser) {
    const supplierUserId = crypto.randomUUID();
    supplierUser = await UserModel.create({
      _id: supplierUserId,
      email: 'supplier@naseeji.com',
      phone: '+201000000002',
      passwordHash: defaultPasswordHash,
      role: 'supplier',
      status: 'active',
      isEmailVerified: true,
      isPhoneVerified: true,
    });

    supplierId = crypto.randomUUID();
    await SupplierModel.create({
      _id: supplierId,
      userId: supplierUserId,
      companyName: 'Naseeji Master Textile Mills',
      slug: 'naseeji-master-textile-mills',
      description: 'Premier Egyptian B2B Cotton & Synthetic Fabric Manufacturer',
      supplierCategory: 'fabric_manufacturer',
      businessType: 'manufacturer',
      phone: '+201000000002',
      email: 'supplier@naseeji.com',
      governorate: 'Alexandria',
      city: 'Alexandria',
      address: 'Textile Hub, Zone 2, Alexandria',
      commercialRegistration: 'CR-500600700',
      taxNumber: `TAX-400300200`,
      verificationStatus: 'verified',
      verificationLevel: 'verified',
      isVerified: true,
      subscriptionStatus: 'active',
      isActive: true,
    });

    await WalletModel.create({
      _id: crypto.randomUUID(),
      userId: supplierUserId,
      balance: 10000,
      pointsBalance: 1000,
      currency: 'EGP',
    });

    console.log(
      '✅ Verified Supplier User Seeded (email: supplier@naseeji.com / pass: Password@123)',
    );
  } else {
    const existingSupplier = await SupplierModel.findOne({ userId: supplierUser._id });
    supplierId = existingSupplier ? existingSupplier._id : '';
    console.log('ℹ️ Supplier User already exists.');
  }

  if (supplierId) {
    const existingStore = await StoreModel.findOne({ supplierId });
    if (!existingStore) {
      await StoreModel.create({
        _id: crypto.randomUUID(),
        supplierId,
        name: 'Naseeji Master Textile Mills Official Store',
        slug: 'naseeji-master-textile-mills',
        description: 'Official Marketplace Store for Premium Egyptian Cotton Fabrics',
        status: 'active',
        isPublic: true,
      });
      console.log('✅ Supplier Official Store Seeded (slug: naseeji-master-textile-mills)');
    }
  }

  // 3c. Admin User
  let adminUser = await UserModel.findOne({ email: 'admin@naseeji.com' });
  if (!adminUser) {
    const adminUserId = crypto.randomUUID();
    adminUser = await UserModel.create({
      _id: adminUserId,
      email: 'admin@naseeji.com',
      phone: '+201000000000',
      passwordHash: defaultPasswordHash,
      role: 'admin',
      status: 'active',
      isEmailVerified: true,
      isPhoneVerified: true,
    });

    await WalletModel.create({
      _id: crypto.randomUUID(),
      userId: adminUserId,
      balance: 0,
      pointsBalance: 9999,
      currency: 'EGP',
    });

    console.log('✅ Admin User Seeded (email: admin@naseeji.com / pass: Password@123)');
  } else {
    console.log('ℹ️ Admin User already exists.');
  }

  // 4. Seed Catalog Categories (Idempotent)
  console.log('📦 Seeding Catalog Categories...');
  const rootCategories = [
    { name: 'Fabrics', slug: 'fabrics', description: 'Raw and finished textiles and fabrics', isFeatured: true, sortOrder: 1 },
    { name: 'Yarn', slug: 'yarn', description: 'Natural and synthetic yarns', isFeatured: true, sortOrder: 2 },
    { name: 'Accessories', slug: 'accessories', description: 'Zippers, buttons, threads, and trims', isFeatured: false, sortOrder: 3 },
    { name: 'Packaging', slug: 'packaging', description: 'Textile packaging bags and materials', isFeatured: false, sortOrder: 4 },
  ];

  const categoryMap = new Map<string, string>();

  for (const cat of rootCategories) {
    let existing = await CategoryModel.findOne({ slug: cat.slug });
    if (!existing) {
      existing = await CategoryModel.create({
        _id: crypto.randomUUID(),
        name: cat.name,
        slug: cat.slug,
        description: cat.description,
        level: 0,
        status: 'active',
        sortOrder: cat.sortOrder,
        isFeatured: cat.isFeatured,
        productCount: 0,
      });
    }
    categoryMap.set(cat.slug, existing._id);
  }

  const fabricsId = categoryMap.get('fabrics');
  if (fabricsId) {
    const fabricSubcategories = [
      { name: 'Cotton', slug: 'cotton', description: '100% Organic and Egyptian Cotton fabrics', parentId: fabricsId, level: 1 },
      { name: 'Polyester', slug: 'polyester', description: 'Durable synthetic polyester blends', parentId: fabricsId, level: 1 },
      { name: 'Denim', slug: 'denim', description: 'Heavyweight indigo denim fabrics', parentId: fabricsId, level: 1 },
    ];

    for (const sub of fabricSubcategories) {
      let existingSub = await CategoryModel.findOne({ slug: sub.slug });
      if (!existingSub) {
        existingSub = await CategoryModel.create({
          _id: crypto.randomUUID(),
          name: sub.name,
          slug: sub.slug,
          description: sub.description,
          parentId: sub.parentId,
          level: sub.level,
          status: 'active',
          sortOrder: 1,
          isFeatured: true,
          productCount: 0,
        });
      }
      categoryMap.set(sub.slug, existingSub._id);
    }
  }

  console.log('✅ Seeded Root Categories & Subcategories.');

  // 5. Seed Catalog Brands (Idempotent)
  console.log('🏷️ Seeding Catalog Brands...');
  const defaultBrands = [
    { name: 'NASEEJI', slug: 'naseeji', description: 'Official NASEEJI Signature Line' },
    { name: 'Egyptian Cotton', slug: 'egyptian-cotton', description: 'Certified Long-Staple Egyptian Cotton' },
    { name: 'Nile Textile', slug: 'nile-textile', description: 'Industrial High-Grade Fabrics' },
  ];

  const brandMap = new Map<string, string>();

  for (const b of defaultBrands) {
    let existingBrand = await BrandModel.findOne({ slug: b.slug });
    if (!existingBrand) {
      existingBrand = await BrandModel.create({
        _id: crypto.randomUUID(),
        name: b.name,
        slug: b.slug,
        description: b.description,
        status: 'active',
      });
    }
    brandMap.set(b.slug, existingBrand._id);
  }
  console.log('✅ Seeded Catalog Brands.');

  // 6. Seed Catalog Products (Idempotent)
  if (supplierId) {
    const store = await StoreModel.findOne({ supplierId });
    if (store) {
      console.log('🧵 Seeding Test Products for Supplier...');
      const cottonCategoryId = categoryMap.get('cotton') || categoryMap.get('fabrics');
      const brandId = brandMap.get('egyptian-cotton');

      const sampleProducts = [
        {
          sku: 'EGY-COT-1001',
          name: 'Premium 100% Egyptian Cotton Twill Fabric',
          slug: 'premium-100-egyptian-cotton-twill-fabric',
          shortDescription: 'Luxurious long-staple combed cotton twill for apparel.',
          description: 'High thread count Egyptian cotton twill fabric suitable for shirts, trousers, and uniforms.',
          productType: 'physical',
          price: 150,
          compareAtPrice: 180,
          currency: 'EGP',
          minimumOrderQuantity: 50,
          stockQuantity: 5000,
          unit: 'meter',
          leadTimeDays: 3,
          status: 'active',
          visibility: 'public',
          isFeatured: true,
          isNegotiable: true,
          allowRFQ: true,
          originCountry: 'Egypt',
          originCity: 'Alexandria',
          specifications: [
            { key: 'Material', value: '100% Long-Staple Cotton' },
            { key: 'Weight', value: '220 GSM' },
            { key: 'Width', value: '160 cm' },
          ],
          keywords: ['cotton', 'egyptian', 'twill', 'fabric', 'apparel'],
        },
        {
          sku: 'DEN-RAW-2002',
          name: 'Heavyweight Indigo Raw Denim Roll',
          slug: 'heavyweight-indigo-raw-denim-roll',
          shortDescription: '14oz rigid indigo selvedge raw denim.',
          description: 'Durable 14oz indigo raw denim for jeans and jacket production.',
          productType: 'physical',
          price: 220,
          currency: 'EGP',
          minimumOrderQuantity: 100,
          stockQuantity: 2500,
          unit: 'meter',
          leadTimeDays: 5,
          status: 'active',
          visibility: 'public',
          isFeatured: true,
          isNegotiable: true,
          allowRFQ: true,
          originCountry: 'Egypt',
          originCity: 'Alexandria',
          specifications: [
            { key: 'Material', value: '98% Cotton, 2% Elastane' },
            { key: 'Weight', value: '14 oz' },
          ],
          keywords: ['denim', 'indigo', 'raw', 'jeans'],
        },
      ];

      for (const p of sampleProducts) {
        let existingProd = await ProductModel.findOne({ sku: p.sku });
        if (!existingProd) {
          existingProd = await ProductModel.create({
            _id: crypto.randomUUID(),
            supplierId,
            storeId: store._id,
            categoryId: cottonCategoryId || '',
            brandId: brandId || undefined,
            sku: p.sku,
            name: p.name,
            slug: p.slug,
            shortDescription: p.shortDescription,
            description: p.description,
            productType: p.productType as any,
            price: p.price,
            compareAtPrice: p.compareAtPrice,
            currency: p.currency,
            minimumOrderQuantity: p.minimumOrderQuantity,
            stockQuantity: p.stockQuantity,
            unit: p.unit,
            leadTimeDays: p.leadTimeDays,
            status: p.status as any,
            visibility: p.visibility as any,
            isFeatured: p.isFeatured,
            isNegotiable: p.isNegotiable,
            allowRFQ: p.allowRFQ,
            rating: 4.8,
            ratingCount: 12,
            totalOrders: 45,
            viewCount: 320,
            originCountry: p.originCountry,
            originCity: p.originCity,
            specifications: p.specifications,
            attributes: {},
            keywords: p.keywords,
            publishedAt: new Date(),
          });

          await ProductMediaModel.create({
            _id: crypto.randomUUID(),
            productId: existingProd._id,
            type: 'image',
            url: 'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2',
            fileSize: 1024 * 500,
            mimeType: 'image/jpeg',
            sortOrder: 0,
            isPrimary: true,
          });

          if (cottonCategoryId) {
            await CategoryModel.findByIdAndUpdate(cottonCategoryId, { $inc: { productCount: 1 } });
          }
        }
      }
      console.log('✅ Seeded Sample Supplier Products & Media.');
    }
  }

  console.log('🎉 Database Seeding Completed Successfully.');
  await mongoose.disconnect();
};

if (process.argv[1] && process.argv[1].endsWith('seed.ts')) {
  seedDatabase().catch((err) => {
    console.error('❌ Seeding Error:', err);
    process.exit(1);
  });
}
