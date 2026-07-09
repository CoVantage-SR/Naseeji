import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class CreateOfferSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const CreateOfferSectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              SizedBox(width: 8),
              Icon(icon, color: color, size: 18),
            ],
          ),
          SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class CreateOfferInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final int maxLines;
  final TextAlign textAlign;
  final IconData? suffixIcon;
  final String? suffixText;

  const CreateOfferInputField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.textAlign = TextAlign.end,
    this.suffixIcon,
    this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 6),
          ],
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            textAlign: textAlign,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: AppColors.outline, fontSize: 12),
              suffixText: suffixText,
              suffixStyle: TextStyle(color: AppColors.outline, fontSize: 12, fontWeight: FontWeight.normal),
              suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: AppColors.outline, size: 18) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E1EF), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E1EF), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CreateOfferHeader extends StatelessWidget {
  final String rfqId;

  const CreateOfferHeader({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'طلب رقم #$rfqId',
          style: TextStyle(
            color: Color(0xFF0040E0),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'أقمشة قطنية فاخرة - توريد مصانع',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE2F9F5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'عميل موثق: نسيجك',
                    style: TextStyle(
                      color: Color(0xFF006B5F),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.verified, color: Color(0xFF006B5F), size: 12),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PricingQuantitiesCard extends StatelessWidget {
  final TextEditingController unitPriceController;
  final TextEditingController qtyController;
  final TextEditingController moqController;

  const PricingQuantitiesCard({
    super.key,
    required this.unitPriceController,
    required this.qtyController,
    required this.moqController,
  });

  @override
  Widget build(BuildContext context) {
    return CreateOfferSectionCard(
      icon: Icons.payments_outlined,
      title: 'التسعير والكميات',
      color: const Color(0xFF0040E0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CreateOfferInputField(
            label: 'سعر الوحدة (جنيه)',
            controller: unitPriceController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CreateOfferInputField(
                  label: 'الكمية المتاحة',
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CreateOfferInputField(
                  label: 'الحد الأدنى (MOQ)',
                  controller: moqController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LogisticsServicesCard extends StatelessWidget {
  final TextEditingController prodPeriodController;
  final TextEditingController shippingCostController;
  final TextEditingController deliveryPeriodController;

  const LogisticsServicesCard({
    super.key,
    required this.prodPeriodController,
    required this.shippingCostController,
    required this.deliveryPeriodController,
  });

  @override
  Widget build(BuildContext context) {
    return CreateOfferSectionCard(
      icon: Icons.local_shipping_outlined,
      title: 'الخدمات اللوجستية',
      color: const Color(0xFF006B5F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CreateOfferInputField(
            label: 'مدة الإنتاج (يوم)',
            controller: prodPeriodController,
            suffixText: 'يوم عمل',
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CreateOfferInputField(
                  label: 'تكلفة الشحن (جنيه)',
                  controller: shippingCostController,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CreateOfferInputField(
                  label: 'مدة التوصيل',
                  controller: deliveryPeriodController,
                  suffixText: 'يومي',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TermsConditionsCard extends StatelessWidget {
  final TextEditingController vatController;
  final TextEditingController cashDiscountController;
  final TextEditingController paymentTermsController;
  final TextEditingController validityController;

  const TermsConditionsCard({
    super.key,
    required this.vatController,
    required this.cashDiscountController,
    required this.paymentTermsController,
    required this.validityController,
  });

  @override
  Widget build(BuildContext context) {
    return CreateOfferSectionCard(
      icon: Icons.gavel_outlined,
      title: 'الشروط والأحكام',
      color: const Color(0xFF993100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: CreateOfferInputField(
                  label: 'الضريبة المضافة (%)',
                  controller: vatController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: CreateOfferInputField(
                  label: 'خصم النقدي (%)',
                  controller: cashDiscountController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          CreateOfferInputField(
            label: 'شروط الدفع',
            controller: paymentTermsController,
          ),
          SizedBox(height: 16),
          CreateOfferInputField(
            label: 'صلاحية العرض',
            controller: validityController,
            hintText: 'mm/dd/yyyy',
            suffixIcon: Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }
}

class AdditionalNotesCard extends StatelessWidget {
  final TextEditingController notesController;

  const AdditionalNotesCard({super.key, required this.notesController});

  @override
  Widget build(BuildContext context) {
    return CreateOfferSectionCard(
      icon: Icons.description_outlined,
      title: 'ملاحظات إضافية',
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      child: CreateOfferInputField(
        label: '',
        controller: notesController,
        hintText: 'اكتب أي تفاصيل إضافية للعميل هنا...',
        maxLines: 4,
      ),
    );
  }
}

class CreateOfferAttachmentsCard extends StatelessWidget {
  const CreateOfferAttachmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CreateOfferSectionCard(
      icon: Icons.attachment_outlined,
      title: 'المرفقات',
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFE2E1EF),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFE8F0FE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: Color(0xFF0040E0),
                size: 28,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'اضغط لرفع الملفات أو اسحبها هنا',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'PDF, PNG, JPG (الحد الأقصى 10 ميجابايت)',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreateOfferBottomBar extends StatelessWidget {
  final String rfqId;
  final VoidCallback onSaveDraft;
  final VoidCallback onSend;

  const CreateOfferBottomBar({
    super.key,
    required this.rfqId,
    required this.onSaveDraft,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SafeArea(
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () => context.push('/orders/offer-preview?rfqId=$rfqId'),
              icon: const Icon(Icons.visibility_outlined, size: 16, color: AppColors.outline),
              label: Text(
                'معاينة',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.outline,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: onSaveDraft,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0040E0),
                side: const BorderSide(color: Color(0xFF0040E0), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              child: Text(
                'حفظ كمسودة',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: onSend,
              icon: const Icon(Icons.send, size: 16, color: Colors.white),
              label: Text(
                'إرسال عرض السعر',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surface,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0040E0),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                minimumSize: const Size(0, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
