import '../../domain/entities/account_entities.dart';

/// Centralized Mock Database for Account & ERP Module
class AccountMockDatabase {
  AccountMockDatabase._();

  static final AccountMockDatabase instance = AccountMockDatabase._();

  // In-memory reactive state fields
  FactoryProfileEntity _factoryProfile = const FactoryProfileEntity(
    id: 'FAC-001',
    name: 'مصانع النسيج الحديثة',
    logoUrl: 'https://images.unsplash.com/photo-1664575198263-269a022d6e14?w=200',
    coverUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
    description: 'مصنع متخصص في صناعة الملابس الجاهزة والغزل والنسيج عالي الجودة.',
    establishedYear: '١٩٩٥',
    industry: 'الغزل والنسيج',
    factoryType: 'مصنع ملابس جاهزة',
    productionCapacity: '٥٠٠ طن / شهرياً',
    employeeCount: 24,
    minOrderQuantity: 500,
    marketsServed: ['مصر', 'السعودية', 'الإمارات'],
    phone: '+20 10 1234 5678',
    email: 'info@naseeji.com',
    website: 'www.naseeji.com',
    country: 'مصر',
    city: 'المحلة الكبرى',
    address: 'المنطقة الصناعية، المحلة الكبرى',
    commercialRegNo: '٤٨٧٢٦١٩',
    taxCardNo: '٣٢١-٩٨٧-٦٥٤',
    isVerified: true,
    subscriptionPlan: 'بريميوم',
    subscriptionStatus: 'نشط',
    subscriptionExpiry: '2025/06/20',
    subscriptionStartDate: '2024/06/20',
    productsPurchased: 14,
    productsLimit: 50,
    isAccountActive: true,
    memberSince: 'يناير 2024',
    branches: ['فرع المحلة الرئيسية', 'فرع القاهرة - العاشر من رمضان'],
    licenses: ['ترخيص التصدير الدولي', 'ترخيص الجودة الصناعية ISO-9001'],
    isoCertificates: ['ISO 9001:2015', 'ISO 14001:2015', 'OEKO-TEX Standard 100'],
  );

  WalletEntity _wallet = const WalletEntity(
    balance: 125450.0,
    pendingBalance: 18500.0,
    currency: 'ج.م',
    invoicesCount: 18,
    bankAccounts: [
      BankAccountEntity(
        id: 'BA-01',
        bankName: 'البنك التجاري الدولي (CIB)',
        accountName: 'مصانع النسيج الحديثة',
        accountNumber: '10004829104',
        iban: 'EG4900020001000482910400012',
        isDefault: true,
      ),
      BankAccountEntity(
        id: 'BA-02',
        bankName: 'بنك مصر',
        accountName: 'مصانع النسيج الحديثة',
        accountNumber: '34001928374',
        iban: 'EG1200030003400192837400015',
        isDefault: false,
      ),
    ],
    instapayHandle: 'naseeji.factory@instapay',
    transactions: [
      WalletTransactionEntity(
        id: 'TXN-901',
        title: 'استلام دفعة طلبية أقمشة قطنية',
        date: '2026/07/28 - 14:30',
        amount: 45000.0,
        isCredit: true,
        status: 'مكتمل',
        type: 'دفعة طلب',
      ),
      WalletTransactionEntity(
        id: 'TXN-902',
        title: 'سحب أرباح إلى حساب CIB',
        date: '2026/07/25 - 11:15',
        amount: 20000.0,
        isCredit: false,
        status: 'مكتمل',
        type: 'سحب أرباح',
      ),
      WalletTransactionEntity(
        id: 'TXN-903',
        title: 'تجديد اشتراك باقة بريميوم',
        date: '2026/06/20 - 09:00',
        amount: 12000.0,
        isCredit: false,
        status: 'مكتمل',
        type: 'رسوم اشتراك',
      ),
      WalletTransactionEntity(
        id: 'TXN-904',
        title: 'عربون طلب خيوط بوليستر (قيد المعالجة)',
        date: '2026/07/29 - 16:45',
        amount: 18500.0,
        isCredit: true,
        status: 'معلق',
        type: 'دفعة طلب',
      ),
    ],
  );

  RewardStateEntity _rewards = const RewardStateEntity(
    currentPoints: 2340,
    earnedPoints: 4800,
    usedPoints: 2460,
    tierName: 'الذهبي',
    availableRewards: [
      RewardItemEntity(
        id: 'REW-101',
        title: 'خصم 15% على اشتراك السنوية',
        pointsCost: 1000,
        description: 'خصم مباشر عند تجديد خطة بريميوم السنوية.',
        category: 'اشتراكات',
      ),
      RewardItemEntity(
        id: 'REW-102',
        title: 'إبراز المصنع في الصفحة الرئيسية (7 أيام)',
        pointsCost: 1500,
        description: 'رفع تقييم الظهور في نتائج البحث والصفحة الرئيسية.',
        category: 'تسويق',
      ),
      RewardItemEntity(
        id: 'REW-103',
        title: 'شحن مجاني لأول طلبية توريد',
        pointsCost: 2000,
        description: 'تغطية تكاليف الشحن المحلي لطلب توريد واحد.',
        category: 'شحن',
      ),
    ],
    history: [
      RewardHistoryEntity(
        id: 'RH-01',
        title: 'استبدال نقاط لخصم اشتراك',
        points: -1000,
        date: '2026/06/15',
        type: 'استبدال',
      ),
      RewardHistoryEntity(
        id: 'RH-02',
        title: 'مكافأة إكمال 10 صفقات ناجحة',
        points: 500,
        date: '2026/07/10',
        type: 'اكتساب',
      ),
      RewardHistoryEntity(
        id: 'RH-03',
        title: 'نقاط تقييم موردين ممتاز',
        points: 200,
        date: '2026/07/20',
        type: 'اكتساب',
      ),
    ],
  );

  List<EmployeeEntity> _employees = [
    const EmployeeEntity(
      id: 'EMP-001',
      name: 'أحمد محمود السيد',
      jobTitle: 'مالك المصنع',
      phone: '+20 10 1234 5678',
      email: 'ahmed@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
      role: 'owner',
      status: 'active',
      department: 'الإدارة العليا',
      lastLogin: 'منذ ٥ دقائق',
      permissions: {
        'المنتجات': true, 'عروض الأسعار': true, 'الطلبات': true,
        'المالية': true, 'التقارير': true, 'الموظفون': true, 'الإعدادات': true,
      },
    ),
    const EmployeeEntity(
      id: 'EMP-002',
      name: 'سارة عبدالله خالد',
      jobTitle: 'مدير المشتريات',
      phone: '+20 11 9876 5432',
      email: 'sara@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100',
      role: 'purchasingManager',
      status: 'active',
      department: 'المشتريات',
      lastLogin: 'منذ ساعتين',
      permissions: {
        'المنتجات': true, 'عروض الأسعار': true, 'الطلبات': true,
        'المالية': false, 'التقارير': false, 'الموظفون': false, 'الإعدادات': false,
      },
    ),
    const EmployeeEntity(
      id: 'EMP-003',
      name: 'محمود طاهر',
      jobTitle: 'محاسب عام',
      phone: '+20 12 4455 6677',
      email: 'mahmoud@naseeji.com',
      photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
      role: 'accountant',
      status: 'active',
      department: 'الحسابات',
      lastLogin: 'منذ يوم',
      permissions: {
        'المنتجات': false, 'عروض الأسعار': false, 'الطلبات': false,
        'المالية': true, 'التقارير': true, 'الموظفون': false, 'الإعدادات': false,
      },
    ),
  ];

  List<NotificationItemEntity> _notifications = [
    const NotificationItemEntity(
      id: 'NOTIF-01',
      title: 'شحنة قماش قطني جاهزة التسليم',
      description: 'تم إصدار الفاتورة وتأكيد جودة الشحنة لطلب #DEAL-2504-0012',
      timeAgo: 'منذ 20 دقيقة',
      category: 'Deals',
      isRead: false,
    ),
    const NotificationItemEntity(
      id: 'NOTIF-02',
      title: 'تم قبول طلب عرض السعر RFQ #102',
      description: 'قام مورد "الهرم للغزول" بتقديم عرض سعر جديد.',
      timeAgo: 'منذ ساعة',
      category: 'RFQ',
      isRead: false,
    ),
    const NotificationItemEntity(
      id: 'NOTIF-03',
      title: 'إيداع نقدي جديد في المحفظة',
      description: 'تم إضافة مبلغ 45,000 ج.م لحسابك التجاري.',
      timeAgo: 'منذ 3 ساعات',
      category: 'Payments',
      isRead: true,
    ),
    const NotificationItemEntity(
      id: 'NOTIF-04',
      title: 'تنبيه أمان: دخول جديد لحسابك',
      description: 'تم تسجيل الدخول من متصفح Chrome - القاهرة.',
      timeAgo: 'منذ 5 ساعات',
      category: 'System',
      isRead: true,
    ),
  ];

  List<SupportTicketEntity> _supportTickets = [
    const SupportTicketEntity(
      id: 'TCK-8801',
      subject: 'استفسار عن ربط الحساب البنكي بالحساب الإلكتروني',
      category: 'المالية والفواتير',
      status: 'قيد المعالجة',
      createdAt: '2026/07/25',
      lastUpdate: 'منذ يوم',
      messagesCount: 3,
    ),
    const SupportTicketEntity(
      id: 'TCK-8802',
      subject: 'طلب إضافة ترخيص صناعي جديد لملف المصنع',
      category: 'البيانات والمستندات',
      status: 'مغلقة',
      createdAt: '2026/07/10',
      lastUpdate: '2026/07/12',
      messagesCount: 5,
    ),
  ];

  List<LoginSessionEntity> _loginSessions = [
    const LoginSessionEntity(
      id: 'SES-01',
      deviceName: 'Samsung Galaxy S24 Ultra',
      location: 'القاهرة، مصر',
      ipAddress: '197.38.12.44',
      isCurrentDevice: true,
      lastActive: 'الآن',
    ),
    const LoginSessionEntity(
      id: 'SES-02',
      deviceName: 'MacBook Pro 16"',
      location: 'المحلة الكبرى، مصر',
      ipAddress: '156.204.89.12',
      isCurrentDevice: false,
      lastActive: 'منذ 3 ساعات',
    ),
  ];

  // Getters
  FactoryProfileEntity get factoryProfile => _factoryProfile;
  WalletEntity get wallet => _wallet;
  RewardStateEntity get rewards => _rewards;
  List<EmployeeEntity> get employees => List.unmodifiable(_employees);
  List<NotificationItemEntity> get notifications => List.unmodifiable(_notifications);
  List<SupportTicketEntity> get supportTickets => List.unmodifiable(_supportTickets);
  List<LoginSessionEntity> get loginSessions => List.unmodifiable(_loginSessions);

  // Mutations
  void updateFactoryProfile(FactoryProfileEntity updated) {
    _factoryProfile = updated;
  }

  void withdrawMoney(double amount, String bankId) {
    if (_wallet.balance >= amount) {
      final updatedTxns = [
        WalletTransactionEntity(
          id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          title: 'طلب سحب رصيد بنكي',
          date: 'الآن',
          amount: amount,
          isCredit: false,
          status: 'مكتمل',
          type: 'سحب أرباح',
        ),
        ..._wallet.transactions,
      ];

      _wallet = WalletEntity(
        balance: _wallet.balance - amount,
        pendingBalance: _wallet.pendingBalance,
        currency: _wallet.currency,
        invoicesCount: _wallet.invoicesCount,
        bankAccounts: _wallet.bankAccounts,
        instapayHandle: _wallet.instapayHandle,
        transactions: updatedTxns,
      );
    }
  }

  void depositMoney(double amount) {
    final updatedTxns = [
      WalletTransactionEntity(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: 'إيداع نقدي سريـع',
        date: 'الآن',
        amount: amount,
        isCredit: true,
        status: 'مكتمل',
        type: 'إيداع',
      ),
      ..._wallet.transactions,
    ];

    _wallet = WalletEntity(
      balance: _wallet.balance + amount,
      pendingBalance: _wallet.pendingBalance,
      currency: _wallet.currency,
      invoicesCount: _wallet.invoicesCount,
      bankAccounts: _wallet.bankAccounts,
      instapayHandle: _wallet.instapayHandle,
      transactions: updatedTxns,
    );
  }

  void redeemReward(RewardItemEntity reward) {
    if (_rewards.currentPoints >= reward.pointsCost) {
      final updatedHistory = [
        RewardHistoryEntity(
          id: 'RH-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
          title: 'استبدال: ${reward.title}',
          points: -reward.pointsCost,
          date: 'الآن',
          type: 'استبدال',
        ),
        ..._rewards.history,
      ];

      _rewards = RewardStateEntity(
        currentPoints: _rewards.currentPoints - reward.pointsCost,
        earnedPoints: _rewards.earnedPoints,
        usedPoints: _rewards.usedPoints + reward.pointsCost,
        tierName: _rewards.tierName,
        availableRewards: _rewards.availableRewards,
        history: updatedHistory,
      );
    }
  }

  void addEmployee(EmployeeEntity emp) {
    _employees = [emp, ..._employees];
    _factoryProfile = FactoryProfileEntity(
      id: _factoryProfile.id,
      name: _factoryProfile.name,
      logoUrl: _factoryProfile.logoUrl,
      coverUrl: _factoryProfile.coverUrl,
      description: _factoryProfile.description,
      establishedYear: _factoryProfile.establishedYear,
      industry: _factoryProfile.industry,
      factoryType: _factoryProfile.factoryType,
      productionCapacity: _factoryProfile.productionCapacity,
      employeeCount: _employees.length,
      minOrderQuantity: _factoryProfile.minOrderQuantity,
      marketsServed: _factoryProfile.marketsServed,
      phone: _factoryProfile.phone,
      email: _factoryProfile.email,
      website: _factoryProfile.website,
      country: _factoryProfile.country,
      city: _factoryProfile.city,
      address: _factoryProfile.address,
      commercialRegNo: _factoryProfile.commercialRegNo,
      taxCardNo: _factoryProfile.taxCardNo,
      isVerified: _factoryProfile.isVerified,
      subscriptionPlan: _factoryProfile.subscriptionPlan,
      subscriptionStatus: _factoryProfile.subscriptionStatus,
      subscriptionExpiry: _factoryProfile.subscriptionExpiry,
      subscriptionStartDate: _factoryProfile.subscriptionStartDate,
      productsPurchased: _factoryProfile.productsPurchased,
      productsLimit: _factoryProfile.productsLimit,
      isAccountActive: _factoryProfile.isAccountActive,
      memberSince: _factoryProfile.memberSince,
      branches: _factoryProfile.branches,
      licenses: _factoryProfile.licenses,
      isoCertificates: _factoryProfile.isoCertificates,
    );
  }

  void updateEmployee(EmployeeEntity updated) {
    _employees = _employees.map((e) => e.id == updated.id ? updated : e).toList();
  }

  void removeEmployee(String id) {
    _employees = _employees.where((e) => e.id != id).toList();
  }

  void markNotificationRead(String id) {
    _notifications = _notifications.map((n) {
      if (n.id == id) {
        return NotificationItemEntity(
          id: n.id,
          title: n.title,
          description: n.description,
          timeAgo: n.timeAgo,
          category: n.category,
          isRead: true,
        );
      }
      return n;
    }).toList();
  }

  void markAllNotificationsRead() {
    _notifications = _notifications.map((n) {
      return NotificationItemEntity(
        id: n.id,
        title: n.title,
        description: n.description,
        timeAgo: n.timeAgo,
        category: n.category,
        isRead: true,
      );
    }).toList();
  }

  void deleteNotification(String id) {
    _notifications = _notifications.where((n) => n.id != id).toList();
  }

  void renewSubscription(String newPlanName) {
    _factoryProfile = FactoryProfileEntity(
      id: _factoryProfile.id,
      name: _factoryProfile.name,
      logoUrl: _factoryProfile.logoUrl,
      coverUrl: _factoryProfile.coverUrl,
      description: _factoryProfile.description,
      establishedYear: _factoryProfile.establishedYear,
      industry: _factoryProfile.industry,
      factoryType: _factoryProfile.factoryType,
      productionCapacity: _factoryProfile.productionCapacity,
      employeeCount: _factoryProfile.employeeCount,
      minOrderQuantity: _factoryProfile.minOrderQuantity,
      marketsServed: _factoryProfile.marketsServed,
      phone: _factoryProfile.phone,
      email: _factoryProfile.email,
      website: _factoryProfile.website,
      country: _factoryProfile.country,
      city: _factoryProfile.city,
      address: _factoryProfile.address,
      commercialRegNo: _factoryProfile.commercialRegNo,
      taxCardNo: _factoryProfile.taxCardNo,
      isVerified: true,
      subscriptionPlan: newPlanName,
      subscriptionStatus: 'نشط',
      subscriptionExpiry: '2026/07/30',
      subscriptionStartDate: '2025/07/30',
      productsPurchased: _factoryProfile.productsPurchased,
      productsLimit: newPlanName == 'المؤسسات' ? 200 : 100,
      isAccountActive: true,
      memberSince: _factoryProfile.memberSince,
      branches: _factoryProfile.branches,
      licenses: _factoryProfile.licenses,
      isoCertificates: _factoryProfile.isoCertificates,
    );
  }

  void createSupportTicket(String subject, String category, String details) {
    final ticket = SupportTicketEntity(
      id: 'TCK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      subject: subject,
      category: category,
      status: 'جديد',
      createdAt: 'الآن',
      lastUpdate: 'الآن',
      messagesCount: 1,
    );
    _supportTickets = [ticket, ..._supportTickets];
  }

  void logoutAllSessions() {
    _loginSessions = _loginSessions.where((s) => s.isCurrentDevice).toList();
  }
}
