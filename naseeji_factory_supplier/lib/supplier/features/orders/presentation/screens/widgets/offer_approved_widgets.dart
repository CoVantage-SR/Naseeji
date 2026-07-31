import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../domain/entities/offer_approved.dart';

class ApprovalHeader extends StatelessWidget {
  final OfferApproved details;

  const ApprovalHeader({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0040E0).withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Color(0xFF0040E0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          'تمت الموافقة على العرض!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'تم تأكيد عرض السعر بنجاح، يمكنك الآن المتابعة لإنشاء الطلب أو إصدار الفاتورة الأولية.',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class OfferSummaryCard extends StatelessWidget {
  final OfferApproved details;

  const OfferSummaryCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.receipt_outlined, color: Color(0xFF0040E0), size: 20),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'ملخص عرض السعر',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF72F8E4).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'QO-2024-${details.rfqId}',
                      style: TextStyle(
                        color: Color(0xFF006B5F),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('تاريخ التوريد', details.deliveryDate, icon: Icons.calendar_today_outlined),
              _buildSummaryItem('سعر المتر', details.meterPrice),
            ],
          ),
          SizedBox(height: 14),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الإجمالي الكلي',
              style: TextStyle(fontSize: 11, color: AppColors.outline),
            ),
          ),
          SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              details.totalPrice,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0040E0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10, color: AppColors.outline),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            if (icon != null) ...[
              SizedBox(width: 4),
              Icon(icon, color: AppColors.outline, size: 12),
            ],
          ],
        ),
      ],
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final OfferApproved details;

  const PaymentMethodCard({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                details.paymentMethodTitle,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              SizedBox(width: 8),
              const Icon(Icons.account_balance_outlined, color: AppColors.outline, size: 20),
            ],
          ),
          SizedBox(height: 10),
          Text(
            details.paymentMethodDesc,
            style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.end,
          ),
          SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'تفاصيل الحساب البنكي',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0040E0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 6),
                Icon(Icons.info_outline, color: Color(0xFF0040E0), size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NextStepsCard extends StatelessWidget {
  const NextStepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'ما هي الخطوة التالية؟',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF006B5F), size: 16),
                  label: Text(
                    'إصدار فاتورة',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006B5F)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF006B5F)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.check_circle_outline, color: AppColors.surface, size: 16),
                  label: Text(
                    'تحويل إلى طلب مؤكد',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0040E0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    minimumSize: const Size(0, 40),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'هل لديك استفسار؟ تواصل مع مدير الحساب',
                style: TextStyle(color: AppColors.outline, fontSize: 11),
              ),
              SizedBox(width: 6),
              Icon(Icons.headset_mic_outlined, color: AppColors.outline, size: 14),
            ],
          ),
        ],
      ),
    );
  }
}

