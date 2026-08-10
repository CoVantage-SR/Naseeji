export interface PermissionDefinition {
  code: string;
  group: string;
  description: string;
}

export const PERMISSIONS_CATALOG: PermissionDefinition[] = [
  // User permissions
  { code: 'users.read', group: 'users', description: 'View user profiles and list users' },
  { code: 'users.update', group: 'users', description: 'Update user profiles' },
  { code: 'users.delete', group: 'users', description: 'Delete or deactivate user accounts' },

  // Role permissions
  { code: 'roles.read', group: 'roles', description: 'View system roles and permissions' },
  { code: 'roles.create', group: 'roles', description: 'Create new custom roles' },
  {
    code: 'roles.update',
    group: 'roles',
    description: 'Modify custom roles and permission mappings',
  },
  { code: 'roles.delete', group: 'roles', description: 'Delete custom roles' },

  // Permission management
  {
    code: 'permissions.read',
    group: 'permissions',
    description: 'List available system permissions',
  },

  // Product permissions
  { code: 'products.read', group: 'products', description: 'View product catalog and details' },
  { code: 'products.create', group: 'products', description: 'Create new product listings' },
  { code: 'products.update', group: 'products', description: 'Update product listings' },
  { code: 'products.delete', group: 'products', description: 'Delete product listings' },

  // Supplier permissions
  {
    code: 'suppliers.read',
    group: 'suppliers',
    description: 'View supplier profiles and directory',
  },
  { code: 'suppliers.update', group: 'suppliers', description: 'Update supplier company profile' },
  {
    code: 'suppliers.verify',
    group: 'suppliers',
    description: 'Verify supplier business documents',
  },
  {
    code: 'suppliers.suspend',
    group: 'suppliers',
    description: 'Suspend or reactivate supplier marketplace access',
  },

  // Store permissions
  { code: 'store.read', group: 'store', description: 'View store information and settings' },
  { code: 'store.create', group: 'store', description: 'Create supplier marketplace store' },
  { code: 'store.update', group: 'store', description: 'Update supplier marketplace store' },
  {
    code: 'store.delete',
    group: 'store',
    description: 'Delete or close supplier marketplace store',
  },

  // Factory permissions
  {
    code: 'factories.read',
    group: 'factories',
    description: 'View factory profiles and directory',
  },
  { code: 'factories.update', group: 'factories', description: 'Update factory company profile' },

  // RFQ permissions
  { code: 'rfq.read', group: 'rfq', description: 'View request for quotations' },
  { code: 'rfq.create', group: 'rfq', description: 'Create new request for quotation' },
  { code: 'rfq.respond', group: 'rfq', description: 'Submit quotation responses to RFQs' },
  { code: 'rfq.update', group: 'rfq', description: 'Update request for quotation' },

  // Order permissions
  { code: 'orders.read', group: 'orders', description: 'View purchase orders and details' },
  { code: 'orders.create', group: 'orders', description: 'Create new purchase orders' },
  { code: 'orders.update', group: 'orders', description: 'Update purchase order status' },
  { code: 'orders.cancel', group: 'orders', description: 'Cancel purchase orders' },

  // Payment permissions
  {
    code: 'payments.read',
    group: 'payments',
    description: 'View transaction history and invoices',
  },
  {
    code: 'payments.create',
    group: 'payments',
    description: 'Initiate payments and escrow funding',
  },

  // Shipping permissions
  { code: 'shipping.read', group: 'shipping', description: 'View shipment tracking information' },
  {
    code: 'shipping.update',
    group: 'shipping',
    description: 'Update shipment and logistics status',
  },

  // Chat permissions
  { code: 'chat.read', group: 'chat', description: 'Read B2B chat messages' },
  { code: 'chat.send', group: 'chat', description: 'Send B2B chat messages' },

  // Report & Analytics permissions
  { code: 'reports.read', group: 'reports', description: 'View business reports and analytics' },

  // Admin access
  { code: 'admin.access', group: 'admin', description: 'Access administrative portal features' },
];

export const DEFAULT_ROLE_PERMISSIONS: Record<string, string[]> = {
  ADMIN: ['*'],
  admin: ['*'],

  FACTORY: [
    'users.read',
    'users.update',
    'factories.read',
    'factories.update',
    'products.read',
    'suppliers.read',
    'rfq.create',
    'rfq.read',
    'rfq.update',
    'orders.create',
    'orders.read',
    'orders.update',
    'payments.read',
    'payments.create',
    'shipping.read',
    'chat.read',
    'chat.send',
    'reports.read',
  ],
  factory: [
    'users.read',
    'users.update',
    'factories.read',
    'factories.update',
    'products.read',
    'suppliers.read',
    'rfq.create',
    'rfq.read',
    'rfq.update',
    'orders.create',
    'orders.read',
    'orders.update',
    'payments.read',
    'payments.create',
    'shipping.read',
    'chat.read',
    'chat.send',
    'reports.read',
  ],

  SUPPLIER: [
    'users.read',
    'users.update',
    'suppliers.read',
    'suppliers.update',
    'store.read',
    'store.create',
    'store.update',
    'store.delete',
    'products.read',
    'products.create',
    'products.update',
    'products.delete',
    'factories.read',
    'rfq.read',
    'rfq.respond',
    'orders.read',
    'orders.update',
    'payments.read',
    'shipping.read',
    'shipping.update',
    'chat.read',
    'chat.send',
    'reports.read',
  ],
  supplier: [
    'users.read',
    'users.update',
    'suppliers.read',
    'suppliers.update',
    'store.read',
    'store.create',
    'store.update',
    'store.delete',
    'products.read',
    'products.create',
    'products.update',
    'products.delete',
    'factories.read',
    'rfq.read',
    'rfq.respond',
    'orders.read',
    'orders.update',
    'payments.read',
    'shipping.read',
    'shipping.update',
    'chat.read',
    'chat.send',
    'reports.read',
  ],

  EMPLOYEE: [
    'products.read',
    'suppliers.read',
    'factories.read',
    'rfq.read',
    'orders.read',
    'chat.read',
    'chat.send',
  ],
  employee: [
    'products.read',
    'suppliers.read',
    'factories.read',
    'rfq.read',
    'orders.read',
    'chat.read',
    'chat.send',
  ],
};
