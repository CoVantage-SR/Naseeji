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

dotenv.config({ path: path.resolve(process.cwd(), '.env') });

const mongoUri =
  process.env.MONGODB_URI || 'mongodb://admin:admin123@127.0.0.1:27017/naseeji?authSource=admin';

export const seedDatabase = async (): Promise<void> => {
  console.log('🌱 Connecting to MongoDB for Database Seeding...');
  await mongoose.connect(mongoUri);

  const defaultPasswordHash = await bcrypt.hash('Password@123', 12);

  // 1. Seed Factory User
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

  // 2. Seed Supplier User
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

  // 3. Seed Admin User
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
