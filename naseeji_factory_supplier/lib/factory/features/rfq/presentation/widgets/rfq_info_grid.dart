import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/rfq_provider.dart';

/// Grid of 6 RFQ Information Cards matching Reference Image 1
class RFQInfoGrid extends StatelessWidget {
  final RFQ rfq;

  const RFQInfoGrid({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'معلومات الطلب',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          // Row 1: نوع الطلب | الكمية المطلوبة | وحدة القياس
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  isDark: isDark,
                  icon: Icons.grid_view_rounded,
                  label: 'نوع الطلب',
                  val: rfq.productName,
                  primaryColor: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoCard(
                  context,
                  isDark: isDark,
                  icon: Icons.straighten_rounded,
                  label: 'الكمية المطلوبة',
                  val: '${rfq.requestedQty.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ${rfq.unit.split(' ').first}',
                  primaryColor: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoCard(
                  context,
                  isDark: isDark,
                  icon: Icons.texture_rounded,
                  label: 'وحدة القياس',
                  val: rfq.unit,
                  primaryColor: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Row 2: الموقع/بلد التسليم | موعد التسليم المتوقع | شروط الدفع
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  isDark: isDark,
                  icon: Icons.location_on_outlined,
                  label: 'الموقع / بلد التسليم',
                  val: rfq.deliveryAddress,
                  primaryColor: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoCard(
                  context,
                  isDark: isDark,
                  icon: Icons.calendar_month_outlined,
                  label: 'موعد التسليم المتوقع',
                  val: rfq.deliveryDate,
                  primaryColor: primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoCard(
                  context,
                  isDark: isDark,
                  icon: Icons.credit_card_outlined,
                  label: 'شروط الدفع',
                  val: rfq.paymentTerms,
                  primaryColor: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required String label,
    required String val,
    required Color primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.blue.shade50.withValues(alpha: 0.3),
        borderRadius: AppRadius.rSM,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.blue.shade100.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 18, color: primaryColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  val,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

