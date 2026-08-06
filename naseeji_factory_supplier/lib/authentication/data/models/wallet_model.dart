class WalletModel {
  final String id;
  final double balance;
  final int pointsBalance;
  final String currency;

  WalletModel({
    required this.id,
    required this.balance,
    required this.pointsBalance,
    required this.currency,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? json['_id'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      pointsBalance: json['pointsBalance'] ?? 0,
      currency: json['currency'] ?? 'EGP',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'pointsBalance': pointsBalance,
      'currency': currency,
    };
  }
}
