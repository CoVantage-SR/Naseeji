import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/orders_provider.dart';
import '../widgets/production_progress_widgets.dart';

class ProductionProgressScreen extends ConsumerStatefulWidget {
  final String orderId;

  const ProductionProgressScreen({super.key, required this.orderId});

  @override
  ConsumerState<ProductionProgressScreen> createState() => _ProductionProgressScreenState();
}

class _ProductionProgressScreenState extends ConsumerState<ProductionProgressScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _stages = const [
    'قبل الإنتاج',
    'أثناء الإنتاج',
    'التعبئة والتغليف',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _stages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = ref.watch(ordersNotifierProvider.notifier).getOrderById(widget.orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('الطلب المطلوب غير موجود.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('متابعة خط الإنتاج'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProgressHeaderWidget(order: order),
              AppSpacing.hMD,
              ProductionProgressWidget(order: order),
              AppSpacing.hMD,
              ProgressStatisticsWidget(order: order),
              AppSpacing.hMD,
              RecentUpdatesWidget(orderId: widget.orderId),
              AppSpacing.hMD,
              PrimaryCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ملفات الجودة المصاحبة للإنتاج',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/orders/${widget.orderId}/gallery'),
                            icon: const Icon(Icons.photo_library_outlined, size: 16),
                            label: const Text('معرض الصور الفني', style: TextStyle(fontSize: 10)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.push('/orders/${widget.orderId}/videos'),
                            icon: const Icon(Icons.video_collection_outlined, size: 16),
                            label: const Text('سجل الفيديوهات', style: TextStyle(fontSize: 10)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}


