import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/offer_approved.dart';

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
                decoration: const BoxDecoration(
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
        const SizedBox(height: 20),
        const Text(
          'تمت الموافقة على العرض!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'تم تأكيد عرض السعر بنجاح، يمكنك الآن المتابعة لإنشاء الطلب أو إصدار الفاتورة الأولية.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
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
        color: Colors.white,
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
                  const Text(
                    'ملخص عرض السعر',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF72F8E4).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'QO-2024-${details.rfqId}',
                      style: const TextStyle(
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
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('تاريخ التوريد', details.deliveryDate, icon: Icons.calendar_today_outlined),
              _buildSummaryItem('سعر المتر', details.meterPrice),
            ],
          ),
          const SizedBox(height: 14),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'الإجمالي الكلي',
              style: TextStyle(fontSize: 11, color: AppColors.outline),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              details.totalPrice,
              style: const TextStyle(
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
          style: const TextStyle(fontSize: 10, color: AppColors.outline),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
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
        color: Colors.white,
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
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.account_balance_outlined, color: AppColors.outline, size: 20),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            details.paymentMethodDesc,
            style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
            textAlign: TextAlign.end,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F1F5)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: const Row(
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'ما هي الخطوة التالية؟',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF006B5F), size: 16),
                  label: const Text(
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
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                  label: const Text(
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
          const SizedBox(height: 14),
          const Row(
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
