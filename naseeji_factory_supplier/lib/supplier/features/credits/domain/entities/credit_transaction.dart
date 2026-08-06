import 'package:flutter/foundation.dart';

@immutable
class CreditTransaction {
  final String id;
  final String supplierId;
  final String operation; // e.g. 'توثيق الحساب الزرقاء', 'إضافة منتج', 'إضافة فيديو منتج', 'مكافأة التسجيل الأول', 'شراء نقاط'
  final int amount; // -35, -5, -10, +50, +100
  final int balanceBefore;
  final int balanceAfter;
  final DateTime createdAt;

  const CreditTransaction({
    required this.id,
    required this.supplierId,
    required this.operation,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.createdAt,
  });

  bool get isDeduction => amount < 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierId': supplierId,
      'operation': operation,
      'amount': amount,
      'balanceBefore': balanceBefore,
      'balanceAfter': balanceAfter,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CreditTransaction.fromJson(Map<String, dynamic> json) {
    return CreditTransaction(
      id: json['id'] as String,
      supplierId: json['supplierId'] as String,
      operation: json['operation'] as String,
      amount: json['amount'] as int,
      balanceBefore: json['balanceBefore'] as int,
      balanceAfter: json['balanceAfter'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
