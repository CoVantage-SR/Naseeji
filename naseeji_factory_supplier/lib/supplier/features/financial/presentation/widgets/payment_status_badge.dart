import 'package:flutter/material.dart';
import '../../domain/entities/financial_models.dart';

class PaymentStatusBadge extends StatelessWidget {
  final dynamic status;

  const PaymentStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;
    String label;

    // Resolve TransactionStatus, PaymentStatus, InvoiceStatus, WithdrawalStatus or String status
    if (status is TransactionStatus) {
      switch (status as TransactionStatus) {
        case TransactionStatus.completed:
          color = const Color(0xFF00875A);
          bgColor = const Color(0xFFE3FCEF);
          label = 'مكتمل';
          break;
        case TransactionStatus.pending:
          color = const Color(0xFFB17000);
          bgColor = const Color(0xFFFFFAE6);
          label = 'قيد الانتظار';
          break;
        case TransactionStatus.failed:
          color = const Color(0xFFDE350B);
          bgColor = const Color(0xFFFFEBE6);
          label = 'فاشل';
          break;
      }
    } else if (status is PaymentStatus) {
      switch (status as PaymentStatus) {
        case PaymentStatus.released:
          color = const Color(0xFF00875A);
          bgColor = const Color(0xFFE3FCEF);
          label = 'تم الإفراج';
          break;
        case PaymentStatus.pending:
          color = const Color(0xFFB17000);
          bgColor = const Color(0xFFFFFAE6);
          label = 'معلق في الضمان';
          break;
        case PaymentStatus.processing:
          color = const Color(0xFF0052CC);
          bgColor = const Color(0xFFDEEBFF);
          label = 'جاري المعالجة';
          break;
        case PaymentStatus.failed:
          color = const Color(0xFFDE350B);
          bgColor = const Color(0xFFFFEBE6);
          label = 'فشلت الدفعة';
          break;
        case PaymentStatus.refunded:
          color = const Color(0xFF4A154B);
          bgColor = const Color(0xFFF3E5F5);
          label = 'مستردة';
          break;
        default:
          color = Colors.grey.shade700;
          bgColor = Colors.grey.shade100;
          label = 'غير معروف';
      }
    } else if (status is InvoiceStatus) {
      switch (status as InvoiceStatus) {
        case InvoiceStatus.paid:
          color = const Color(0xFF00875A);
          bgColor = const Color(0xFFE3FCEF);
          label = 'مدفوعة';
          break;
        case InvoiceStatus.pending:
          color = const Color(0xFFB17000);
          bgColor = const Color(0xFFFFFAE6);
          label = 'قيد الاستحقاق';
          break;
        case InvoiceStatus.overdue:
          color = const Color(0xFFDE350B);
          bgColor = const Color(0xFFFFEBE6);
          label = 'متأخرة';
          break;
        case InvoiceStatus.cancelled:
          color = Colors.grey.shade600;
          bgColor = Colors.grey.shade100;
          label = 'ملغاة';
          break;
      }
    } else if (status is WithdrawalStatus) {
      switch (status as WithdrawalStatus) {
        case WithdrawalStatus.completed:
          color = const Color(0xFF00875A);
          bgColor = const Color(0xFFE3FCEF);
          label = 'تم التحويل';
          break;
        case WithdrawalStatus.pending:
          color = const Color(0xFFB17000);
          bgColor = const Color(0xFFFFFAE6);
          label = 'قيد التدقيق';
          break;
        case WithdrawalStatus.approved:
          color = const Color(0xFF0052CC);
          bgColor = const Color(0xFFDEEBFF);
          label = 'مقبول بنكياً';
          break;
        case WithdrawalStatus.rejected:
          color = const Color(0xFFDE350B);
          bgColor = const Color(0xFFFFEBE6);
          label = 'مرفوض';
          break;
      }
    } else {
      // String fallbacks
      final s = status.toString().toLowerCase();
      if (s == 'completed' || s == 'approved' || s == 'paid' || s == 'released') {
        color = const Color(0xFF00875A);
        bgColor = const Color(0xFFE3FCEF);
        label = 'مكتمل';
      } else if (s == 'pending' || s == 'processing') {
        color = const Color(0xFFB17000);
        bgColor = const Color(0xFFFFFAE6);
        label = 'معلق';
      } else if (s == 'rejected' || s == 'failed' || s == 'overdue' || s == 'cancelled') {
        color = const Color(0xFFDE350B);
        bgColor = const Color(0xFFFFEBE6);
        label = 'مرفوض/فاشل';
      } else {
        color = Colors.grey.shade700;
        bgColor = Colors.grey.shade100;
        label = status.toString();
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



