import 'package:flutter/material.dart';

class PlansHeader extends StatelessWidget {
  final VoidCallback onBack;

  const PlansHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right: Crown Icon + Title & Subtitle
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مقارنة الباقات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'اختر الباقة المناسبة لاحتياجات مصنعك',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Left: Back button & Notification Bell
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.notifications_none_rounded,
                      color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151),
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CurrentPlanBadge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;

  const CurrentPlanBadge({
    super.key,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String monthlyPrice;
  final String yearlyPrice;
  final IconData icon;
  final Color iconColor;
  final bool isCurrent;
  final bool isPopular;
  final String buttonText;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback? onPressed;

  const PlanCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.icon,
    required this.iconColor,
    this.isCurrent = false,
    this.isPopular = false,
    required this.buttonText,
    required this.buttonColor,
    required this.buttonTextColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? (isCurrent || isPopular ? const Color(0xFF2D1B4E) : const Color(0xFF1E293B))
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPopular
                ? const Color(0xFF9333EA)
                : (isCurrent ? const Color(0xFFC084FC) : (isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB))),
            width: isPopular || isCurrent ? 1.5 : 1,
          ),
          boxShadow: isPopular
              ? [
                  BoxShadow(
                    color: const Color(0xFF9333EA).withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF9333EA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'الأكثر إختياراً',
                  style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: iconColor),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPopular ? (isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)) : (isDark ? Colors.white : const Color(0xFF111827)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
            ),
            const SizedBox(height: 8),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '\$$monthlyPrice ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
                  ),
                  TextSpan(
                    text: '/ شهر',
                    style: TextStyle(fontSize: 10, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            Text(
              'أو \$$yearlyPrice سنوياً',
              style: TextStyle(fontSize: 9.5, color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 34,
              child: ElevatedButton(
                onPressed: isCurrent ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  elevation: 0,
                  side: isCurrent ? BorderSide.none : BorderSide(color: buttonTextColor, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: buttonTextColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureComparisonTable extends StatelessWidget {
  final List<ComparisonRowData> rows;

  const FeatureComparisonTable({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFB),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'المميزات',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151)),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'الأساسية',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'الإحترافية',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF9333EA)),
                  ),
                ),
                const Expanded(
                  flex: 2,
                  child: Text(
                    'المؤسسية',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEA580C)),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),

          // Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rows.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFF3F4F6)),
            itemBuilder: (context, index) {
              final row = rows[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                child: Row(
                  children: [
                    // Feature Name + Icon
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Icon(row.icon, size: 16, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              row.title,
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: isDark ? Colors.white : const Color(0xFF111827)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Starter Value
                    Expanded(
                      flex: 2,
                      child: _buildCellWidget(row.starterValue, const Color(0xFF16A34A)),
                    ),

                    // Professional Value
                    Expanded(
                      flex: 2,
                      child: _buildCellWidget(row.professionalValue, const Color(0xFF9333EA)),
                    ),

                    // Enterprise Value
                    Expanded(
                      flex: 2,
                      child: _buildCellWidget(row.enterpriseValue, const Color(0xFFEA580C)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCellWidget(dynamic value, Color color) {
    if (value is bool) {
      return Icon(
        value ? Icons.check_circle_rounded : Icons.cancel_rounded,
        size: 18,
        color: value ? color : const Color(0xFFDC2626),
      );
    }
    return Text(
      value.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class ComparisonRowData {
  final String title;
  final IconData icon;
  final dynamic starterValue;
  final dynamic professionalValue;
  final dynamic enterpriseValue;

  const ComparisonRowData({
    required this.title,
    required this.icon,
    required this.starterValue,
    required this.professionalValue,
    required this.enterpriseValue,
  });
}

class IncludedFeaturesCard extends StatelessWidget {
  const IncludedFeaturesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D1B4E) : const Color(0xFFFBF7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF581C87) : const Color(0xFFE9D5FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3B0764) : const Color(0xFFF3E8FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'جميع الباقات تشمل',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'نشر المنتجات - التواصل مع المصانع - إدارة الطلبات - تتبع الشحنات - الفواتير الأساسية',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? const Color(0xFFE9D5FF) : const Color(0xFF6B7280),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BottomActionSection extends StatelessWidget {
  final VoidCallback onStartTrial;

  const BottomActionSection({super.key, required this.onStartTrial});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          'لست متأكداً؟',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF111827)),
        ),
        const SizedBox(height: 2),
        Text(
          'جرب الباقة الإحترافية مجاناً لمدة 14 يوم بدون إحتمالية',
          style: TextStyle(fontSize: 11, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: onStartTrial,
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
            label: const Text(
              'ابدأ تجربتك المجانية',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9333EA),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
      ],
    );
  }
}


