import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/orders_provider.dart';

class ProgressHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const ProgressHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'متابعة إنتاج الطلب: ${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          'المنتج: ${order.productName} • المورد: ${order.supplierName}',
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class ProductionProgressWidget extends StatelessWidget {
  final OrderModel order;

  const ProductionProgressWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: order.progressPercentage / 100.0,
                  strokeWidth: 10,
                  color: AppColors.success,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${order.progressPercentage.toInt()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.success),
                  ),
                  const Text('مستوى التقدم', style: TextStyle(color: Colors.grey, fontSize: 8)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'المرحلة الحالية: إنتاج وتجهيز الخيوط وتعبئتها في البكر المخصص',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'تاريخ الاكتمال المقدر: 2026/07/20',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class ProgressStatisticsWidget extends StatelessWidget {
  final OrderModel order;

  const ProgressStatisticsWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        _buildStatBox('الكمية المنجزة', '٩٠٠ وحدة', Icons.shopping_bag_outlined),
        _buildStatBox('الكمية المتبقية', '٦٠٠ وحدة', Icons.hourglass_empty_rounded),
        _buildStatBox('عدد الصور المرفوعة', '٥ صور', Icons.photo_library_outlined),
        _buildStatBox('عدد الفيديوهات', '٢ فيديو', Icons.video_collection_outlined),
      ],
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon) {
    return PrimaryCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                Text(label, style: const TextStyle(color: Colors.grey, fontSize: 8)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecentUpdatesWidget extends StatelessWidget {
  final String orderId;

  const RecentUpdatesWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر ملاحظات وتحديثات الجودة من المورد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildUpdateRow('2026/07/12', 'تم الانتهاء من فحص جودة خط اللف على البكر ومطابقته لكثافة الشد المعتمدة.'),
          _buildUpdateRow('2026/07/08', 'تم غزل ونفش الدفعة الأولى من الخيوط بنجاح وبدء إعداد الدفعة الثانية.'),
        ],
      ),
    );
  }

  Widget _buildUpdateRow(String date, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary, fontSize: 9),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 10, height: 1.4),
          ),
          const Divider(height: 12),
        ],
      ),
    );
  }
}

class PreparationTabsWidget extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const PreparationTabsWidget({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      labelColor: AppColors.primary,
      unselectedLabelColor: Colors.grey,
      indicatorColor: AppColors.primary,
      tabs: tabs.map((t) => Tab(text: t)).toList(),
    );
  }
}
