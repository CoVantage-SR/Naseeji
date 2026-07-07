import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/quotation_model.dart';

class QuotationActionButtons extends StatelessWidget {
  final QuotationModel quotation;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onPreviewPdf;
  final VoidCallback? onSend;
  final VoidCallback? onWithdraw;
  final VoidCallback? onDuplicate;
  final VoidCallback? onOpenChat;
  final VoidCallback? onSendCounterOffer;
  final VoidCallback? onViewHistory;
  final VoidCallback? onUpdateQuotation;
  final VoidCallback? onViewAgreement;
  final VoidCallback? onViewOrder;
  final VoidCallback? onTrackProduction;
  final VoidCallback? onCreateNewVersion;
  final VoidCallback? onViewRejectionReason;
  final VoidCallback? onRenew;
  final VoidCallback? onArchive;

  const QuotationActionButtons({
    super.key,
    required this.quotation,
    this.onEdit,
    this.onDelete,
    this.onPreviewPdf,
    this.onSend,
    this.onWithdraw,
    this.onDuplicate,
    this.onOpenChat,
    this.onSendCounterOffer,
    this.onViewHistory,
    this.onUpdateQuotation,
    this.onViewAgreement,
    this.onViewOrder,
    this.onTrackProduction,
    this.onCreateNewVersion,
    this.onViewRejectionReason,
    this.onRenew,
    this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    switch (quotation.status) {
      case QuotationStatus.draft:
        buttons = [
          _buildOutlineButton(label: 'حذف', icon: Icons.delete_outline, color: AppColors.error, onTap: onDelete),
          const SizedBox(width: 8),
          _buildOutlineButton(label: 'معاينة PDF', icon: Icons.picture_as_pdf_outlined, onTap: onPreviewPdf),
          const SizedBox(width: 8),
          _buildOutlineButton(label: 'تعديل العرض', icon: Icons.edit_outlined, onTap: onEdit),
          const SizedBox(width: 8),
          _buildPrimaryButton(label: 'إرسال العرض', icon: Icons.send_outlined, onTap: onSend),
        ];
        break;
      case QuotationStatus.sent:
        buttons = [
          _buildOutlineButton(label: 'سحب العرض', icon: Icons.undo, color: AppColors.error, onTap: onWithdraw),
          const SizedBox(width: 8),
          _buildOutlineButton(label: 'تكرار', icon: Icons.copy_outlined, onTap: onDuplicate),
          const SizedBox(width: 8),
          _buildPrimaryButton(label: 'المحادثة اللوجستية', icon: Icons.forum_outlined, onTap: onOpenChat),
        ];
        break;
      case QuotationStatus.underNegotiation:
        buttons = [
          _buildOutlineButton(label: 'السجل والتفاصيل', icon: Icons.history_outlined, onTap: onViewHistory),
          const SizedBox(width: 8),
          _buildOutlineButton(label: 'تحديث العرض', icon: Icons.update_outlined, onTap: onUpdateQuotation),
          const SizedBox(width: 8),
          _buildOutlineButton(label: 'محادثة التفاوض', icon: Icons.forum_outlined, onTap: onOpenChat),
          const SizedBox(width: 8),
          _buildPrimaryButton(label: 'إرسال سعر جديد', icon: Icons.gavel, onTap: onSendCounterOffer),
        ];
        break;
      case QuotationStatus.accepted:
        buttons = [
          _buildOutlineButton(label: 'تتبع خط الإنتاج', icon: Icons.precision_manufacturing_outlined, onTap: onTrackProduction),
          const SizedBox(width: 8),
          _buildOutlineButton(label: 'تفاصيل الطلب', icon: Icons.shopping_bag_outlined, onTap: onViewOrder),
          const SizedBox(width: 8),
          _buildPrimaryButton(label: 'عرض العقد المبرم', icon: Icons.handshake_outlined, onTap: onViewAgreement),
        ];
        break;
      case QuotationStatus.rejected:
        buttons = [
          if (quotation.rejectionReason != null) ...[
            _buildOutlineButton(label: 'سبب الرفض', icon: Icons.info_outline, color: AppColors.error, onTap: onViewRejectionReason),
            const SizedBox(width: 8),
          ],
          _buildOutlineButton(label: 'تكرار العرض', icon: Icons.copy_outlined, onTap: onDuplicate),
          const SizedBox(width: 8),
          _buildPrimaryButton(label: 'إصدار نسخة جديدة', icon: Icons.add_outlined, onTap: onCreateNewVersion),
        ];
        break;
      case QuotationStatus.expired:
        buttons = [
          _buildOutlineButton(label: 'أرشفة العرض', icon: Icons.archive_outlined, onTap: onArchive),
          const SizedBox(width: 8),
          _buildOutlineButton(label: 'تكرار العرض', icon: Icons.copy_outlined, onTap: onDuplicate),
          const SizedBox(width: 8),
          _buildPrimaryButton(label: 'تجديد الصلاحية', icon: Icons.refresh_outlined, onTap: onRenew),
        ];
        break;
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: buttons,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlineButton({required String label, required IconData icon, Color? color, VoidCallback? onTap}) {
    final activeColor = color ?? AppColors.primary;
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 14, color: activeColor),
      label: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: activeColor)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: activeColor.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  Widget _buildPrimaryButton({required String label, required IconData icon, VoidCallback? onTap}) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(icon, size: 14, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        elevation: 0,
      ),
    );
  }
}
