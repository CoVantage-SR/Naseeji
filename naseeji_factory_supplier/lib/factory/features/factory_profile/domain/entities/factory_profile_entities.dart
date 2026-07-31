class FactoryProfileEntity {
  final String id;
  final String name;
  final String commercialName;
  final String factoryType;
  final String industry;
  final String logoUrl;
  final String coverUrl;
  final bool isVerified;
  final String verificationStatus; // 'verified', 'pending', 'rejected', 'expired'
  final String verificationDate;
  final String reviewer;
  final String membershipDate;
  final String status; // 'مفعل', 'غير مفعل'
  final String subscriptionPlan; // 'بريميوم', 'مجاني', 'احترافي'
  final String subscriptionExpiry;
  final String commercialRegister;
  final String taxNumber;
  final String vatNumber;
  final String establishmentDate;
  final String factorySize;
  final int employeesCount;
  final String annualCapacity;
  final String description;

  const FactoryProfileEntity({
    required this.id,
    required this.name,
    required this.commercialName,
    required this.factoryType,
    required this.industry,
    required this.logoUrl,
    required this.coverUrl,
    required this.isVerified,
    required this.verificationStatus,
    required this.verificationDate,
    required this.reviewer,
    required this.membershipDate,
    required this.status,
    required this.subscriptionPlan,
    required this.subscriptionExpiry,
    required this.commercialRegister,
    required this.taxNumber,
    required this.vatNumber,
    required this.establishmentDate,
    required this.factorySize,
    required this.employeesCount,
    required this.annualCapacity,
    required this.description,
  });

  FactoryProfileEntity copyWith({
    String? id,
    String? name,
    String? commercialName,
    String? factoryType,
    String? industry,
    String? logoUrl,
    String? coverUrl,
    bool? isVerified,
    String? verificationStatus,
    String? verificationDate,
    String? reviewer,
    String? membershipDate,
    String? status,
    String? subscriptionPlan,
    String? subscriptionExpiry,
    String? commercialRegister,
    String? taxNumber,
    String? vatNumber,
    String? establishmentDate,
    String? factorySize,
    int? employeesCount,
    String? annualCapacity,
    String? description,
  }) {
    return FactoryProfileEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      commercialName: commercialName ?? this.commercialName,
      factoryType: factoryType ?? this.factoryType,
      industry: industry ?? this.industry,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      isVerified: isVerified ?? this.isVerified,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verificationDate: verificationDate ?? this.verificationDate,
      reviewer: reviewer ?? this.reviewer,
      membershipDate: membershipDate ?? this.membershipDate,
      status: status ?? this.status,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      commercialRegister: commercialRegister ?? this.commercialRegister,
      taxNumber: taxNumber ?? this.taxNumber,
      vatNumber: vatNumber ?? this.vatNumber,
      establishmentDate: establishmentDate ?? this.establishmentDate,
      factorySize: factorySize ?? this.factorySize,
      employeesCount: employeesCount ?? this.employeesCount,
      annualCapacity: annualCapacity ?? this.annualCapacity,
      description: description ?? this.description,
    );
  }
}

class FactoryLocationEntity {
  final String country;
  final String governorate;
  final String city;
  final String industrialZone;
  final String address;
  final String googleMapsUrl;
  final String gpsCoordinates;

  const FactoryLocationEntity({
    required this.country,
    required this.governorate,
    required this.city,
    required this.industrialZone,
    required this.address,
    required this.googleMapsUrl,
    required this.gpsCoordinates,
  });

  FactoryLocationEntity copyWith({
    String? country,
    String? governorate,
    String? city,
    String? industrialZone,
    String? address,
    String? googleMapsUrl,
    String? gpsCoordinates,
  }) {
    return FactoryLocationEntity(
      country: country ?? this.country,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      industrialZone: industrialZone ?? this.industrialZone,
      address: address ?? this.address,
      googleMapsUrl: googleMapsUrl ?? this.googleMapsUrl,
      gpsCoordinates: gpsCoordinates ?? this.gpsCoordinates,
    );
  }
}

class FactoryContactEntity {
  final String companyEmail;
  final String phoneNumber;
  final String mobile;
  final String whatsApp;
  final String website;
  final String linkedIn;
  final String facebook;
  final String emergencyContact;

  const FactoryContactEntity({
    required this.companyEmail,
    required this.phoneNumber,
    required this.mobile,
    required this.whatsApp,
    required this.website,
    required this.linkedIn,
    required this.facebook,
    required this.emergencyContact,
  });

  FactoryContactEntity copyWith({
    String? companyEmail,
    String? phoneNumber,
    String? mobile,
    String? whatsApp,
    String? website,
    String? linkedIn,
    String? facebook,
    String? emergencyContact,
  }) {
    return FactoryContactEntity(
      companyEmail: companyEmail ?? this.companyEmail,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mobile: mobile ?? this.mobile,
      whatsApp: whatsApp ?? this.whatsApp,
      website: website ?? this.website,
      linkedIn: linkedIn ?? this.linkedIn,
      facebook: facebook ?? this.facebook,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }
}

class FactoryPurchasingInfoEntity {
  final String purchasingManager;
  final String position;
  final String email;
  final String phone;
  final String workingHours;
  final String preferredContactTime;

  const FactoryPurchasingInfoEntity({
    required this.purchasingManager,
    required this.position,
    required this.email,
    required this.phone,
    required this.workingHours,
    required this.preferredContactTime,
  });

  FactoryPurchasingInfoEntity copyWith({
    String? purchasingManager,
    String? position,
    String? email,
    String? phone,
    String? workingHours,
    String? preferredContactTime,
  }) {
    return FactoryPurchasingInfoEntity(
      purchasingManager: purchasingManager ?? this.purchasingManager,
      position: position ?? this.position,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      workingHours: workingHours ?? this.workingHours,
      preferredContactTime: preferredContactTime ?? this.preferredContactTime,
    );
  }
}

class FactoryBillingEntity {
  final String companyName;
  final String taxAddress;
  final String invoiceEmail;
  final String paymentTerms;
  final String preferredCurrency;
  final List<FactoryBankAccountEntity> bankAccounts;
  final String instapay;
  final String swift;
  final String iban;

  const FactoryBillingEntity({
    required this.companyName,
    required this.taxAddress,
    required this.invoiceEmail,
    required this.paymentTerms,
    required this.preferredCurrency,
    required this.bankAccounts,
    required this.instapay,
    required this.swift,
    required this.iban,
  });

  FactoryBillingEntity copyWith({
    String? companyName,
    String? taxAddress,
    String? invoiceEmail,
    String? paymentTerms,
    String? preferredCurrency,
    List<FactoryBankAccountEntity>? bankAccounts,
    String? instapay,
    String? swift,
    String? iban,
  }) {
    return FactoryBillingEntity(
      companyName: companyName ?? this.companyName,
      taxAddress: taxAddress ?? this.taxAddress,
      invoiceEmail: invoiceEmail ?? this.invoiceEmail,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      bankAccounts: bankAccounts ?? this.bankAccounts,
      instapay: instapay ?? this.instapay,
      swift: swift ?? this.swift,
      iban: iban ?? this.iban,
    );
  }
}

class FactoryBankAccountEntity {
  final String id;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String iban;
  final bool isDefault;

  const FactoryBankAccountEntity({
    required this.id,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.iban,
    required this.isDefault,
  });
}

class FactoryDocumentEntity {
  final String id;
  final String title;
  final String documentNumber;
  final String documentType;
  final String status; // 'سارية', 'منتهية', 'قيد التجديد'
  final String expiryDate;
  final String fileUrl;
  final int version;

  const FactoryDocumentEntity({
    required this.id,
    required this.title,
    required this.documentNumber,
    required this.documentType,
    required this.status,
    required this.expiryDate,
    required this.fileUrl,
    required this.version,
  });

  FactoryDocumentEntity copyWith({
    String? id,
    String? title,
    String? documentNumber,
    String? documentType,
    String? status,
    String? expiryDate,
    String? fileUrl,
    int? version,
  }) {
    return FactoryDocumentEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      documentNumber: documentNumber ?? this.documentNumber,
      documentType: documentType ?? this.documentType,
      status: status ?? this.status,
      expiryDate: expiryDate ?? this.expiryDate,
      fileUrl: fileUrl ?? this.fileUrl,
      version: version ?? this.version,
    );
  }
}

class FactoryGalleryItemEntity {
  final String id;
  final String title;
  final String imageUrl;
  final bool isVideo;
  final String type; // 'photo', 'production_line', 'warehouse', 'certificate', 'video'

  const FactoryGalleryItemEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isVideo = false,
    required this.type,
  });
}


