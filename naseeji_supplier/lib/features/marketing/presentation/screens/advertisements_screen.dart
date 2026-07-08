import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/marketing_controllers.dart';
import '../widgets/advertisement_card.dart';
import '../../domain/entities/marketing_models.dart';

class AdvertisementsScreen extends ConsumerStatefulWidget {
  const AdvertisementsScreen({super.key});

  @override
  ConsumerState<AdvertisementsScreen> createState() => _AdvertisementsScreenState();
}

class _AdvertisementsScreenState extends ConsumerState<AdvertisementsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'الكل',
    'نشط',
    'مجدول',
    'قيد المراجعة',
    'موقوف مؤقتاً',
    'مكتمل',
    'مرفوض'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<B2BAdvertisement> _filterAds(List<B2BAdvertisement> ads, int tabIndex) {
    if (tabIndex == 0) return ads;
    
    AdStatus targetStatus;
    switch (tabIndex) {
      case 1:
        targetStatus = AdStatus.active;
        break;
      case 2:
        targetStatus = AdStatus.scheduled;
        break;
      case 3:
        targetStatus = AdStatus.pendingReview;
        break;
      case 4:
        targetStatus = AdStatus.paused;
        break;
      case 5:
        targetStatus = AdStatus.completed;
        break;
      case 6:
        targetStatus = AdStatus.rejected;
        break;
      default:
        return ads;
    }
    return ads.where((ad) => ad.status == targetStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final adsAsync = ref.watch(marketingAdvertisementsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text(
            'الإعلانات B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: const Color(0xFF0040E0),
            labelColor: const Color(0xFF0040E0),
            unselectedLabelColor: AppColors.outline,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Color(0xFF0040E0)),
              onPressed: () => context.push('/marketing/create-ad'),
            )
          ],
        ),
        body: Material(
          color: const Color(0xFFF8F9FF),
          child: adsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('حدث خطأ: $err')),
            data: (ads) {
              return TabBarView(
                controller: _tabController,
                children: List.generate(_tabs.length, (index) {
                  final filteredList = _filterAds(ads, index);
                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد إعلانات في هذا القسم حالياً.',
                        style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, idx) {
                      final ad = filteredList[idx];
                      return AdvertisementCard(
                        ad: ad,
                        onView: () => context.push('/marketing/ads/${ad.id}', extra: ad),
                        onPauseToggle: () {
                          final newStatus = ad.status == AdStatus.active ? AdStatus.paused : AdStatus.active;
                          ref.read(marketingAdvertisementsControllerProvider.notifier).updateAdStatus(ad.id, newStatus);
                        },
                        onDelete: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('حذف الإعلان', textAlign: TextAlign.right),
                              content: const Text('هل أنت متأكد من رغبتك في حذف هذا الإعلان نهائياً؟', textAlign: TextAlign.right),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref.read(marketingAdvertisementsControllerProvider.notifier).deleteAd(ad.id);
                                    Navigator.pop(ctx);
                                  },
                                  child: const Text('حذف', style: TextStyle(color: Color(0xFFBA1A1A))),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
