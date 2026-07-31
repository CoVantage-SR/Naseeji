import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/customer_model.dart';

class CustomerActionButtons extends StatelessWidget {
  final CustomerModel customer;
  final VoidCallback? onChat;
  final VoidCallback? onOrders;
  final VoidCallback? onAgreements;
  final VoidCallback? onPayments;
  final VoidCallback? onShipments;
  final VoidCallback? onNewQuotation;
  final VoidCallback? onAddNote;
  final VoidCallback? onBlock;
  final VoidCallback? onUnblock;
  final VoidCallback? onArchive;
  final VoidCallback? onDownloadStatement;

  const CustomerActionButtons({
    super.key,
    required this.customer,
    this.onChat,
    this.onOrders,
    this.onAgreements,
    this.onPayments,
    this.onShipments,
    this.onNewQuotation,
    this.onAddNote,
    this.onBlock,
    this.onUnblock,
    this.onArchive,
    this.onDownloadStatement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    final buttons = <Widget>[];

    void addOutline(String label, IconData icon, VoidCallback? onTap, {Color? color}) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 8));
      buttons.add(_buildOutlineBtn(label, icon, onTap, color: color));
    }

    void addPrimary(String label, IconData icon, VoidCallback? onTap) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 8));
      buttons.add(_buildPrimaryBtn(label, icon, onTap));
    }

    // Always available
    addOutline('محادثة', Icons.forum_outlined, onChat);
    addOutline('الطلبات', Icons.shopping_bag_outlined, onOrders);
    addOutline('الاتفاقيات', Icons.handshake_outlined, onAgreements);
    addOutline('المدفوعات', Icons.payments_outlined, onPayments);
    addOutline('ملاحظة', Icons.note_add_outlined, onAddNote);
    addOutline('كشف الحساب', Icons.download_outlined, onDownloadStatement);

    if (customer.status == CustomerStatus.blocked) {
      addPrimary('رفع الحظر', Icons.lock_open_outlined, onUnblock);
    } else {
      addPrimary('عرض سعر جديد', Icons.add_circle_outline, onNewQuotation);
      if (customer.status != CustomerStatus.inactive) {
        addOutline('أرشفة', Icons.archive_outlined, onArchive);
      }
      if (customer.status == CustomerStatus.active || customer.status == CustomerStatus.vip) {
        addOutline('حظر', Icons.block_outlined, onBlock, color: AppColors.error);
      }
    }

    return buttons;
  }

  Widget _buildOutlineBtn(String label, IconData icon, VoidCallback? onTap, {Color? color}) {
    final activeColor = color ?? AppColors.primary;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 13, color: activeColor),
      label: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: activeColor)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: activeColor.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildPrimaryBtn(String label, IconData icon, VoidCallback? onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 13, color: Colors.white),
      label: Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        elevation: 0,
      ),
    );
  }
}


