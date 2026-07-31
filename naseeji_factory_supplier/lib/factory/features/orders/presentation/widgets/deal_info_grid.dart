import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/orders_provider.dart';

/// Grid of 6 Compact Information Cards:
/// 1. المورد (Supplier Name & Logo & Verified Badge)
/// 2. تاريخ الاتفاق (Agreement Date)
/// 3. طريقة الدفع (Payment Method & Terms)
/// 4. مدة التسليم (Lead Time)
/// 5. بلد المنشأ (Country of Origin)
/// 6. تاريخ التسليم المتوقع (Expected Delivery Date)
class DealInfoGrid extends StatelessWidget {
  final OrderModel order;

  const DealInfoGrid({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        // Row 1: Supplier | Agreement Date | Payment Method
        Row(
          children: [
            // Card 1: Supplier
            Expanded(
              child: _buildCard(
                context,
                isDark: isDark,
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipOval(
                        child: order.supplierLogo.isNotEmpty
                            ? Image.network(
                                order.supplierLogo,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.factory_rounded, size: 18, color: primaryColor),
                              )
                            : Icon(Icons.factory_rounded, size: 18, color: primaryColor),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('المورد', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  order.supplierName,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (order.supplierVerified) ...[
                                const SizedBox(width: 2),
                                const Icon(Icons.verified_rounded, color: AppColors.success, size: 12),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Card 2: Agreement Date
            Expanded(
              child: _buildCard(
                context,
                isDark: isDark,
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تاريخ الاتفاق', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          const SizedBox(height: 2),
                          Text(
                            order.agreementDate,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Card 3: Payment Method
            Expanded(
              child: _buildCard(
                context,
                isDark: isDark,
                child: Row(
                  children: [
                    Icon(Icons.credit_card_outlined, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('طريقة الدفع', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          const SizedBox(height: 2),
                          Text(
                            order.paymentMethod,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            order.paymentTerms,
                            style: TextStyle(fontSize: 8, color: Colors.grey.shade500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Row 2: Lead Time | Country of Origin | Expected Delivery Date
        Row(
          children: [
            // Card 4: Lead Time
            Expanded(
              child: _buildCard(
                context,
                isDark: isDark,
                child: Row(
                  children: [
                    Icon(Icons.access_time_rounded, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('مدة التسليم', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          const SizedBox(height: 2),
                          Text(
                            order.leadTime,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Card 5: Country of Origin
            Expanded(
              child: _buildCard(
                context,
                isDark: isDark,
                child: Row(
                  children: [
                    const Text('🇪🇬', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('بلد المنشأ', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          const SizedBox(height: 2),
                          Text(
                            order.countryOfOrigin,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Card 6: Expected Delivery Date
            Expanded(
              child: _buildCard(
                context,
                isDark: isDark,
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تاريخ التسليم المتوقع', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                          const SizedBox(height: 2),
                          Text(
                            order.expectedDeliveryDate,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'متوقع في الوقت المحدد',
                            style: TextStyle(fontSize: 8, color: AppColors.success, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required bool isDark, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rSM,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
      ),
      child: child,
    );
  }
}


