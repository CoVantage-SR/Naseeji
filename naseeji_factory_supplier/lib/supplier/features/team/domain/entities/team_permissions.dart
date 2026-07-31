class TeamPermissions {
  // Products
  final bool viewProducts;
  final bool addProduct;
  final bool editProduct;
  final bool deleteProduct;
  final bool manageInventory;

  // Deals
  final bool viewDeals;
  final bool manageRfq;
  final bool negotiate;
  final bool signAgreement;

  // Messages
  final bool readMessages;
  final bool sendMessages;
  final bool manageFiles;

  // Production
  final bool startProduction;
  final bool updateProgress;
  final bool finishProduction;

  // Delivery
  final bool manageDelivery;
  final bool updateDeliveryStatus;
  final bool confirmDelivery;

  // Finance
  final bool viewPayments;
  final bool manageInvoices;

  // Admin
  final bool manageEmployees;
  final bool manageSubscription;
  final bool manageCompanyData;

  const TeamPermissions({
    this.viewProducts = true,
    this.addProduct = false,
    this.editProduct = false,
    this.deleteProduct = false,
    this.manageInventory = false,
    this.viewDeals = true,
    this.manageRfq = false,
    this.negotiate = false,
    this.signAgreement = false,
    this.readMessages = true,
    this.sendMessages = true,
    this.manageFiles = false,
    this.startProduction = false,
    this.updateProgress = false,
    this.finishProduction = false,
    this.manageDelivery = false,
    this.updateDeliveryStatus = false,
    this.confirmDelivery = false,
    this.viewPayments = false,
    this.manageInvoices = false,
    this.manageEmployees = false,
    this.manageSubscription = false,
    this.manageCompanyData = false,
  });

  factory TeamPermissions.fullAccess() {
    return const TeamPermissions(
      viewProducts: true, addProduct: true, editProduct: true, deleteProduct: true, manageInventory: true,
      viewDeals: true, manageRfq: true, negotiate: true, signAgreement: true,
      readMessages: true, sendMessages: true, manageFiles: true,
      startProduction: true, updateProgress: true, finishProduction: true,
      manageDelivery: true, updateDeliveryStatus: true, confirmDelivery: true,
      viewPayments: true, manageInvoices: true,
      manageEmployees: true, manageSubscription: true, manageCompanyData: true,
    );
  }

  factory TeamPermissions.sales() {
    return const TeamPermissions(
      viewProducts: true, addProduct: true, editProduct: true, deleteProduct: false, manageInventory: false,
      viewDeals: true, manageRfq: true, negotiate: true, signAgreement: false,
      readMessages: true, sendMessages: true, manageFiles: true,
      startProduction: false, updateProgress: false, finishProduction: false,
      manageDelivery: false, updateDeliveryStatus: false, confirmDelivery: false,
      viewPayments: true, manageInvoices: false,
      manageEmployees: false, manageSubscription: false, manageCompanyData: false,
    );
  }

  factory TeamPermissions.production() {
    return const TeamPermissions(
      viewProducts: true, addProduct: false, editProduct: false, deleteProduct: false, manageInventory: true,
      viewDeals: true, manageRfq: false, negotiate: false, signAgreement: false,
      readMessages: true, sendMessages: true, manageFiles: true,
      startProduction: true, updateProgress: true, finishProduction: true,
      manageDelivery: false, updateDeliveryStatus: false, confirmDelivery: false,
      viewPayments: false, manageInvoices: false,
      manageEmployees: false, manageSubscription: false, manageCompanyData: false,
    );
  }

  factory TeamPermissions.inventory() {
    return const TeamPermissions(
      viewProducts: true, addProduct: true, editProduct: true, deleteProduct: false, manageInventory: true,
      viewDeals: true, manageRfq: false, negotiate: false, signAgreement: false,
      readMessages: true, sendMessages: true, manageFiles: true,
      startProduction: false, updateProgress: false, finishProduction: false,
      manageDelivery: true, updateDeliveryStatus: true, confirmDelivery: false,
      viewPayments: false, manageInvoices: false,
      manageEmployees: false, manageSubscription: false, manageCompanyData: false,
    );
  }

  factory TeamPermissions.finance() {
    return const TeamPermissions(
      viewProducts: true, addProduct: false, editProduct: false, deleteProduct: false, manageInventory: false,
      viewDeals: true, manageRfq: false, negotiate: false, signAgreement: false,
      readMessages: true, sendMessages: true, manageFiles: true,
      startProduction: false, updateProgress: false, finishProduction: false,
      manageDelivery: false, updateDeliveryStatus: false, confirmDelivery: false,
      viewPayments: true, manageInvoices: true,
      manageEmployees: false, manageSubscription: false, manageCompanyData: false,
    );
  }

  TeamPermissions copyWith({
    bool? viewProducts, bool? addProduct, bool? editProduct, bool? deleteProduct, bool? manageInventory,
    bool? viewDeals, bool? manageRfq, bool? negotiate, bool? signAgreement,
    bool? readMessages, bool? sendMessages, bool? manageFiles,
    bool? startProduction, bool? updateProgress, bool? finishProduction,
    bool? manageDelivery, bool? updateDeliveryStatus, bool? confirmDelivery,
    bool? viewPayments, bool? manageInvoices,
    bool? manageEmployees, bool? manageSubscription, bool? manageCompanyData,
  }) {
    return TeamPermissions(
      viewProducts: viewProducts ?? this.viewProducts,
      addProduct: addProduct ?? this.addProduct,
      editProduct: editProduct ?? this.editProduct,
      deleteProduct: deleteProduct ?? this.deleteProduct,
      manageInventory: manageInventory ?? this.manageInventory,
      viewDeals: viewDeals ?? this.viewDeals,
      manageRfq: manageRfq ?? this.manageRfq,
      negotiate: negotiate ?? this.negotiate,
      signAgreement: signAgreement ?? this.signAgreement,
      readMessages: readMessages ?? this.readMessages,
      sendMessages: sendMessages ?? this.sendMessages,
      manageFiles: manageFiles ?? this.manageFiles,
      startProduction: startProduction ?? this.startProduction,
      updateProgress: updateProgress ?? this.updateProgress,
      finishProduction: finishProduction ?? this.finishProduction,
      manageDelivery: manageDelivery ?? this.manageDelivery,
      updateDeliveryStatus: updateDeliveryStatus ?? this.updateDeliveryStatus,
      confirmDelivery: confirmDelivery ?? this.confirmDelivery,
      viewPayments: viewPayments ?? this.viewPayments,
      manageInvoices: manageInvoices ?? this.manageInvoices,
      manageEmployees: manageEmployees ?? this.manageEmployees,
      manageSubscription: manageSubscription ?? this.manageSubscription,
      manageCompanyData: manageCompanyData ?? this.manageCompanyData,
    );
  }
}



