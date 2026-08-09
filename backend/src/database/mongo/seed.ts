/* eslint-disable no-console */
import crypto from 'crypto';
import bcrypt from 'bcrypt';
import mongoose from 'mongoose';
import dotenv from 'dotenv';
import path from 'path';
import { UserModel } from '../../modules/auth/infrastructure/database/user.schema.js';
import { FactoryModel } from '../../modules/auth/infrastructure/database/factory.schema.js';
import { SupplierModel } from '../../modules/auth/infrastructure/database/supplier.schema.js';
import { WalletModel } from '../../modules/auth/infrastructure/database/wallet.schema.js';
import { RoleModel } from '../../modules/auth/infrastructure/database/role.schema.js';
import { PermissionModel } from '../../modules/auth/infrastructure/database/permission.schema.js';
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
      // Update system role permissions to stay in sync with config
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

  // 3b. Supplier User
  let supplierUser = await UserModel.findOne({ email: 'supplier@naseeji.com' });
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

    await SupplierModel.create({
      _id: crypto.randomUUID(),
      userId: supplierUserId,
      companyName: 'Naseeji Master Textile Mills',
      supplierCategory: 'fabric_manufacturer',
      phone: '+201000000002',
      email: 'supplier@naseeji.com',
      governorate: 'Alexandria',
      address: 'Textile Hub, Zone 2, Alexandria',
      commercialRegistration: 'CR-500600700',
      taxNumber: `TAX-400300200`,
      verificationStatus: 'verified',
      subscriptionStatus: 'active',
    });

    await WalletModel.create({
      _id: crypto.randomUUID(),
      userId: supplierUserId,
      balance: 10000,
      pointsBalance: 1000,
      currency: 'EGP',
    });

    console.log('✅ Supplier User Seeded (email: supplier@naseeji.com / pass: Password@123)');
  } else {
    console.log('ℹ️ Supplier User already exists.');
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

  console.log('🎉 Database Seeding Completed Successfully.');
  await mongoose.disconnect();
};

if (process.argv[1] && process.argv[1].endsWith('seed.ts')) {
  seedDatabase().catch((err) => {
    console.error('❌ Seeding Error:', err);
    process.exit(1);
  });
}
