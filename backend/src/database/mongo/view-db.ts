/* eslint-disable no-console */
import mongoose from 'mongoose';
import dotenv from 'dotenv';

dotenv.config();

let mongoUri = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/naseeji';

async function viewDatabase(): Promise<void> {
  console.log('\n======================================================');
  console.log('🔍 NASEEJI DATABASE INSPECTOR');
  console.log('======================================================');

  let conn: mongoose.Connection | undefined;

  try {
    console.log(`Connecting to: ${mongoUri.replace(/:([^@]+)@/, ':****@')}...`);
    conn = await mongoose.createConnection(mongoUri).asPromise();
  } catch {
    if (mongoUri.includes('@')) {
      mongoUri = 'mongodb://127.0.0.1:27017/naseeji';
      console.log(`⚠️ Authenticated URI failed. Retrying with local URI: ${mongoUri}...`);
      conn = await mongoose.createConnection(mongoUri).asPromise();
    }
  }

  if (!conn || !conn.db) {
    console.error('❌ Could not establish database connection.');
    return;
  }

  const db = conn.db;
  const collections = await db.listCollections().toArray();
  console.log(`\n📊 Found ${collections.length} Collections in Database "naseeji":`);
  console.log('------------------------------------------------------');

  for (const col of collections) {
    const count = await db.collection(col.name).countDocuments();
    console.log(` • ${col.name.padEnd(25)} : ${count} documents`);
  }

  console.log('\n------------------------------------------------------');
  console.log('👤 RECENT USERS IN DATABASE:');
  console.log('------------------------------------------------------');
  const users = await db
    .collection('users')
    .find({})
    .project({ passwordHash: 0 })
    .limit(10)
    .toArray();
  console.dir(users, { depth: null, colors: true });

  console.log('\n------------------------------------------------------');
  console.log('🏭 RECENT FACTORY PROFILES:');
  console.log('------------------------------------------------------');
  const factories = await db.collection('factories').find({}).limit(5).toArray();
  console.dir(factories, { depth: null, colors: true });

  await conn.close();
  console.log('\n✅ Database Inspection Completed.\n');
}

viewDatabase();
