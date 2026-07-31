class FactoryProfileEntity {
  final String id;
  final String name;
  final String logoUrl;
  final String coverUrl;
  final String description;
  final String establishedYear;
  final String industry;
  final String factoryType;
  final String productionCapacity;
  final int employeeCount;
  final int minOrderQuantity;
  final List<String> marketsServed;
  final String phone;
  final String email;
  final String website;
  final String country;
  final String city;
  final String address;
  final String commercialRegNo;
  final String taxCardNo;
  final bool isVerified;
  final String subscriptionPlan;
  final String subscriptionStatus;
  final String subscriptionExpiry;
  final String subscriptionStartDate;
  final int productsPurchased;
  final int productsLimit;
  final bool isAccountActive;
  final String memberSince;
  final List<String> branches;
  final List<String> licenses;
  final List<String> isoCertificates;

  const FactoryProfileEntity({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.coverUrl,
    required this.description,
    required this.establishedYear,
    required this.industry,
    required this.factoryType,
    required this.productionCapacity,
    required this.employeeCount,
    required this.minOrderQuantity,
    required this.marketsServed,
    required this.phone,
    required this.email,
    required this.website,
    required this.country,
    required this.city,
    required this.address,
    required this.commercialRegNo,
    required this.taxCardNo,
    required this.isVerified,
    required this.subscriptionPlan,
    required this.subscriptionStatus,
    required this.subscriptionExpiry,
    required this.subscriptionStartDate,
    required this.productsPurchased,
    required this.productsLimit,
    required this.isAccountActive,
    this.memberSince = 'يناير 2024',
    this.branches = const [],
    this.licenses = const [],
    this.isoCertificates = const [],
  });

  FactoryProfileEntity copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? coverUrl,
    String? description,
    String? establishedYear,
    String? industry,
    String? factoryType,
    String? productionCapacity,
    int? employeeCount,
    int? minOrderQuantity,
    List<String>? marketsServed,
    String? phone,
    String? email,
    String? website,
    String? country,
    String? city,
    String? address,
    String? commercialRegNo,
    String? taxCardNo,
    bool? isVerified,
    String? subscriptionPlan,
    String? subscriptionStatus,
    String? subscriptionExpiry,
    String? subscriptionStartDate,
    int? productsPurchased,
    int? productsLimit,
    bool? isAccountActive,
    String? memberSince,
    List<String>? branches,
    List<String>? licenses,
    List<String>? isoCertificates,
  }) {
    return FactoryProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      description: description ?? this.description,
      establishedYear: establishedYear ?? this.establishedYear,
      industry: industry ?? this.industry,
      factoryType: factoryType ?? this.factoryType,
      productionCapacity: productionCapacity ?? this.productionCapacity,
      employeeCount: employeeCount ?? this.employeeCount,
      minOrderQuantity: minOrderQuantity ?? this.minOrderQuantity,
      marketsServed: marketsServed ?? this.marketsServed,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      country: country ?? this.country,
      city: city ?? this.city,
      address: address ?? this.address,
      commercialRegNo: commercialRegNo ?? this.commercialRegNo,
      taxCardNo: taxCardNo ?? this.taxCardNo,
      isVerified: isVerified ?? this.isVerified,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      subscriptionStartDate: subscriptionStartDate ?? this.subscriptionStartDate,
      productsPurchased: productsPurchased ?? this.productsPurchased,
      productsLimit: productsLimit ?? this.productsLimit,
      isAccountActive: isAccountActive ?? this.isAccountActive,
      memberSince: memberSince ?? this.memberSince,
      branches: branches ?? this.branches,
      licenses: licenses ?? this.licenses,
      isoCertificates: isoCertificates ?? this.isoCertificates,
    );
  }
}

class BankAccountEntity {
  final String id;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String iban;
  final bool isDefault;

  const BankAccountEntity({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.iban,
    required this.isDefault,
  });
}

class WalletTransactionEntity {
  final String id;
  final String title;
  final String date;
  final double amount;
  final bool isCredit;
  final String status;
  final String type;

  const WalletTransactionEntity({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.status,
    required this.type,
  });
}

class WalletEntity {
  final double balance;
  final double pendingBalance;
  final String currency;
  final int invoicesCount;
  final List<BankAccountEntity> bankAccounts;
  final String instapayHandle;
  final List<WalletTransactionEntity> transactions;

  const WalletEntity({
    required this.balance,
    required this.pendingBalance,
    required this.currency,
    required this.invoicesCount,
    required this.bankAccounts,
    required this.instapayHandle,
    required this.transactions,
  });
}

class RewardItemEntity {
  final String id;
  final String title;
  final int pointsCost;
  final String description;
  final String category;

  const RewardItemEntity({
    required this.id,
    required this.title,
    required this.pointsCost,
    required this.description,
    required this.category,
  });
}

class RewardHistoryEntity {
  final String id;
  final String title;
  final int points;
  final String date;
  final String type;

  const RewardHistoryEntity({
    required this.id,
    required this.title,
    required this.points,
    required this.date,
    required this.type,
  });
}

class RewardStateEntity {
  final int currentPoints;
  final int earnedPoints;
  final int usedPoints;
  final String tierName;
  final List<RewardItemEntity> availableRewards;
  final List<RewardHistoryEntity> history;

  const RewardStateEntity({
    required this.currentPoints,
    required this.earnedPoints,
    required this.usedPoints,
    required this.tierName,
    required this.availableRewards,
    required this.history,
  });

  int get points => currentPoints;
}

class EmployeeEntity {
  final String id;
  final String name;
  final String jobTitle;
  final String phone;
  final String email;
  final String photoUrl;
  final String role;
  final String status;
  final String department;
  final String lastLogin;
  final Map<String, bool> permissions;

  const EmployeeEntity({
    required this.id,
    required this.name,
    required this.jobTitle,
    required this.phone,
    required this.email,
    required this.photoUrl,
    required this.role,
    required this.status,
    required this.department,
    required this.lastLogin,
    required this.permissions,
  });

  EmployeeEntity copyWith({
    String? id,
    String? name,
    String? jobTitle,
    String? phone,
    String? email,
    String? photoUrl,
    String? role,
    String? status,
    String? department,
    String? lastLogin,
    Map<String, bool>? permissions,
  }) {
    return EmployeeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      department: department ?? this.department,
      lastLogin: lastLogin ?? this.lastLogin,
      permissions: permissions ?? this.permissions,
    );
  }
}

class NotificationItemEntity {
  final String id;
  final String title;
  final String description;
  final String timeAgo;
  final String category;
  final bool isRead;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.category,
    required this.isRead,
  });
}

class SupportTicketEntity {
  final String id;
  final String subject;
  final String category;
  final String status;
  final String createdAt;
  final String lastUpdate;
  final int messagesCount;

  const SupportTicketEntity({
    required this.id,
    required this.subject,
    required this.category,
    required this.status,
    required this.createdAt,
    required this.lastUpdate,
    required this.messagesCount,
  });
}

class LoginSessionEntity {
  final String id;
  final String deviceName;
  final String location;
  final String ipAddress;
  final bool isCurrentDevice;
  final String lastActive;

  const LoginSessionEntity({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.ipAddress,
    required this.isCurrentDevice,
    required this.lastActive,
  });
}

