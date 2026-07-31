import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_providers.dart';

class AnalyticsBottomSheet extends ConsumerWidget {
  final String productId;
  final String productName;

  const AnalyticsBottomSheet({
    super.key,
    required this.productId,
    required this.productName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final analyticsAsync = ref.watch(productAnalyticsProvider(productId));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Header Title
            Row(
              children: [
                Icon(Icons.bar_chart_rounded, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تحليلات وإحصائيات المنتج',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                      Text(
                        productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 16),

            // Body
            analyticsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('خطأ في جلب التحليلات: $err', style: const TextStyle(color: Colors.red, fontSize: 11)),
              ),
              data: (analytics) {
                return Column(
                  children: [
                    // Grid of 6 Main Analytics Mini Cards
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.6,
                      children: [
                        _buildMetricCard(context, 'المشاهدات', '${analytics.views}', Icons.visibility_outlined, Colors.blue),
                        _buildMetricCard(context, 'زيارات الصفحة', '${analytics.pageVisits}', Icons.touch_app_outlined, Colors.indigo),
                        _buildMetricCard(context, 'مرات الحفظ', '${analytics.saves}', Icons.bookmark_border_rounded, Colors.purple),
                        _buildMetricCard(context, 'طلبات RFQ', '${analytics.rfqRequests}', Icons.assignment_outlined, Colors.orange),
                        _buildMetricCard(context, 'عروض الأسعار', '${analytics.quotesSubmitted}', Icons.local_offer_outlined, Colors.teal),
                        _buildMetricCard(context, 'الطلبات المكتملة', '${analytics.completedOrders}', Icons.shopping_bag_outlined, Colors.green),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Conversion Rate & Activity Row
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('معدل التحويل (Conversion)', style: TextStyle(fontSize: 9, color: theme.colorScheme.outline)),
                                const SizedBox(height: 2),
                                Text(
                                  '${analytics.conversionRatePercent}%',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('آخر نشاط وم التفاعل', style: TextStyle(fontSize: 9, color: theme.colorScheme.outline)),
                                const SizedBox(height: 2),
                                Text(
                                  analytics.lastActivityText,
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Top Search Keywords Chips
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('أكثر كلمات البحث المصاحبة للمنتج:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: analytics.topKeywords.map((kw) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerLow,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: theme.colorScheme.outlineVariant),
                              ),
                              child: Text('# $kw', style: TextStyle(fontSize: 9.5, color: theme.colorScheme.onSurface)),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: color),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8.5, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(val, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}


