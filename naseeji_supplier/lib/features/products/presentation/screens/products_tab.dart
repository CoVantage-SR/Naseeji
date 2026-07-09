import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../widgets/subscription_summary_card.dart';
import '../widgets/usage_statistics_card.dart';
import '../widgets/subscription_warning_banner.dart';
import '../widgets/upgrade_dialog.dart';
import '../../../subscription/presentation/controllers/subscription_controllers.dart';

class ProductsTab extends ConsumerStatefulWidget {
  const ProductsTab({super.key});

  @override
  ConsumerState<ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<ProductsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'الكل';
  bool _isBulkActionActive = false;
  final Set<String> _selectedProductIds = {};

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 'p1',
      'name': 'خيوط غزل القطن الفاخر',
      'sku': 'COT-YRN-001',
      'price': '١٢.٥٠ ر.س',
      'stock': 5000,
      'category': 'خيوط',
      'status': 'نشط',
      'image': 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=100&q=80',
    },
    {
      'id': 'p2',
      'name': 'قماش قطني طبيعي ١٠٠٪',
      'sku': 'COT-FAB-002',
      'price': '٤٥.٠٠ ر.س',
      'stock': 2300,
      'category': 'أقمشة',
      'status': 'نشط',
      'image': 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=100&q=80',
    },
    {
      'id': 'p3',
      'name': 'نسيج صوف مخلوط مميز',
      'sku': 'WOL-MIX-003',
      'price': '٨٠.٠٠ ر.س',
      'stock': 950,
      'category': 'أقمشة',
      'status': 'نشط',
      'image': 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=100&q=80',
    },
    {
      'id': 'p4',
      'name': 'خيوط البوليستر المعالجة',
      'sku': 'PLY-YRN-004',
      'price': '٨.٠٠ ر.س',
      'stock': 0,
      'category': 'خيوط',
      'status': 'غير نشط',
      'image': 'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=100&q=80',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSubscriptionDashboardHeader(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(activeSubscriptionControllerProvider);
    final usageAsync = ref.watch(subscriptionUsageControllerProvider);

    return subAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (sub) {
        return usageAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (usage) {
            final double maxProducts = sub.planId == 'free' ? 10.0 : 50.0;
            final double maxAds = sub.planId == 'free' ? 1.0 : 5.0;
            final double maxFeatured = sub.planId == 'free' ? 0.0 : 3.0;
            final double maxStorage = sub.planId == 'free' ? 1.0 : 5.0;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // exp warnings
                  SubscriptionWarningBanner(
                    status: sub.status.name,
                    daysRemaining: sub.remainingDays,
                    onActionTap: () => context.push('/subscription'),
                  ),

                  // Summary Card
                  SubscriptionSummaryCard(
                    subscription: sub,
                    onDetailsTap: () => context.push('/products/usage'),
                  ),
                  SizedBox(height: 12),

                  // Grid of usage progress
                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.3,
                    ),
                    children: [
                      UsageStatisticsCard(
                        title: 'المنتجات المضافة',
                        used: usage.productsUsed.toDouble(),
                        max: maxProducts,
                        unit: 'منتج',
                      ),
                      UsageStatisticsCard(
                        title: 'الإعلانات الممولة',
                        used: usage.advertisementsUsed.toDouble(),
                        max: maxAds,
                        unit: 'إعلان',
                      ),
                      UsageStatisticsCard(
                        title: 'المنتجات المميزة',
                        used: usage.featuredProductsUsed.toDouble(),
                        max: maxFeatured,
                        unit: 'مميز',
                      ),
                      UsageStatisticsCard(
                        title: 'مساحة التخزين',
                        used: usage.storageUsedGb,
                        max: maxStorage,
                        unit: 'جيجابايت',
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Quick Actions Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildActionButton(context, 'تفاصيل الاستهلاك', Icons.info_outline, () => context.push('/products/usage')),
                        SizedBox(width: 8),
                        _buildActionButton(context, 'شراء ملحقات', Icons.add_shopping_cart, () => context.push('/subscription/addons')),
                        SizedBox(width: 8),
                        _buildActionButton(context, 'تجديد الاشتراك', Icons.autorenew, () async {
                          await ref.read(activeSubscriptionControllerProvider.notifier).renew();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم تجديد الباقة وتمديد الصلاحية.')),
                            );
                          }
                        }),
                        SizedBox(width: 8),
                        _buildActionButton(context, 'ترقية الباقة', Icons.upgrade, () => context.push('/subscription/plans')),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: const Color(0xFF0040E0),
        elevation: 0.5,
        minimumSize: const Size(110, 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF0040E0), width: 0.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      icon: Icon(icon, size: 14),
      label: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildFab(WidgetRef ref) {
    final subAsync = ref.watch(activeSubscriptionControllerProvider);
    final usageAsync = ref.watch(subscriptionUsageControllerProvider);

    return subAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (sub) => usageAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
        data: (usage) {
          final maxProducts = sub.planId == 'free' ? 10.0 : 50.0;
          final isLimitReached = usage.productsUsed >= maxProducts;

          return FloatingActionButton.extended(
            onPressed: () {
              if (isLimitReached) {
                showDialog(
                  context: context,
                  builder: (ctx) => UpgradeDialog(
                    title: 'تم بلوغ الحد الأقصى للمنتجات',
                    content: 'لقد استهلكت جميع مساحات المنتجات المتاحة في باقة اشتراكك الحالية (${maxProducts.toStringAsFixed(0)} منتجات). قم بالترقية أو شراء باقة ملحقة لإضافة منتج خام جديد.',
                    onUpgrade: () => context.push('/subscription/plans'),
                    onBuyPack: () => context.push('/subscription/addons'),
                  ),
                );
              } else {
                context.push('/add-product');
              }
            },
            backgroundColor: isLimitReached ? const Color(0xFFBA1A1A) : const Color(0xFF0040E0),
            foregroundColor: Colors.white,
            icon: Icon(isLimitReached ? Icons.upgrade : Icons.add),
            label: Text(
              isLimitReached ? 'ترقية الباقة (تم بلوغ الحد)' : 'إضافة منتج جديد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allProducts.where((p) {
      final matchesQuery = p['name'].toString().contains(_searchQuery) ||
          p['sku'].toString().contains(_searchQuery);
      final matchesCategory = _selectedCategory == 'الكل' || p['category'] == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Subscription Dashboard Header
              _buildSubscriptionDashboardHeader(context, ref),

              // Search and Category filter row
              Container(
                color: Theme.of(context).colorScheme.surface,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppColors.outline),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                style: TextStyle(fontSize: 13),
                                decoration: const InputDecoration(
                                  hintText: 'البحث باسم المنتج أو الرمز...',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                                onChanged: (value) {
                                  setState(() => _searchQuery = value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Category Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCategory,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                          items: ['الكل', 'أقمشة', 'خيوط']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setState(() => _selectedCategory = v);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Header stats & controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      'إجمالي المنتجات: ${filtered.length}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.outline),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isBulkActionActive = !_isBulkActionActive;
                          _selectedProductIds.clear();
                        });
                      },
                      icon: Icon(_isBulkActionActive ? Icons.close : Icons.playlist_add_check, size: 18),
                      label: Text(
                        _isBulkActionActive ? 'إلغاء التحديد' : 'تحديد متعدد',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              // Product List
              filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.widgets_outlined, size: 48, color: AppColors.outlineVariant),
                            SizedBox(height: 12),
                            Text('لا توجد منتجات مطابقة', style: TextStyle(color: AppColors.outline)),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final p = filtered[index];
                        final isSelected = _selectedProductIds.contains(p['id']);

                        return InkWell(
                          onTap: () {
                            if (_isBulkActionActive) {
                              setState(() {
                                if (isSelected) {
                                  _selectedProductIds.remove(p['id']);
                                } else {
                                  _selectedProductIds.add(p['id']);
                                }
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : Colors.transparent,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                if (_isBulkActionActive) ...[
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          _selectedProductIds.add(p['id']);
                                        } else {
                                          _selectedProductIds.remove(p['id']);
                                        }
                                      });
                                    },
                                    activeColor: AppColors.primary,
                                  ),
                                  SizedBox(width: 8),
                                ],
                                // Product Image with error fallback
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    p['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                                      width: 60,
                                      height: 60,
                                      child: const Icon(Icons.image, color: AppColors.outline),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p['name'],
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'الرمز: ${p['sku']}',
                                            style: TextStyle(fontSize: 10, color: AppColors.outline),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                            decoration: BoxDecoration(
                                              color: p['status'] == 'نشط' ? Colors.green.shade50 : Colors.red.shade50,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              p['status'],
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: p['status'] == 'نشط' ? Colors.green.shade700 : Colors.red.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            p['price'],
                                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.primary),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'المخزون: ${p['stock']}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: p['stock'] < 500 ? Colors.orange.shade700 : AppColors.outline,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // Actions Popup Menu (disabled in bulk mode)
                                if (!_isBulkActionActive)
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert, size: 20, color: AppColors.outline),
                                    onSelected: (action) => _handleProductAction(context, action, p),
                                    itemBuilder: (ctx) => [
                                      const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text('تعديل المنتج')])),
                                      const PopupMenuItem(value: 'duplicate', child: Row(children: [Icon(Icons.copy_outlined, size: 18), SizedBox(width: 8), Text('تكرار المنتج')])),
                                      const PopupMenuItem(value: 'share', child: Row(children: [Icon(Icons.share_outlined, size: 18), SizedBox(width: 8), Text('مشاركة')])),
                                      const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text('حذف المنتج', style: TextStyle(color: Colors.red))])),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              // Floating Bulk Actions Bar
              if (_isBulkActionActive && _selectedProductIds.isNotEmpty)
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        'تم تحديد ${_selectedProductIds.length} منتجات',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _allProducts.removeWhere((p) => _selectedProductIds.contains(p['id']));
                            _selectedProductIds.clear();
                            _isBulkActionActive = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم حذف المنتجات المحددة بنجاح.')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 36),
                        ),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: Text('حذف المحدد', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: !_isBulkActionActive
            ? _buildFab(ref)
            : null,
      ),
    );
  }

  void _handleProductAction(BuildContext context, String action, Map<String, dynamic> p) {
    if (action == 'edit') {
      context.push('/add-product');
    } else if (action == 'duplicate') {
      setState(() {
        _allProducts.add({
          ...p,
          'id': 'p_${DateTime.now().millisecondsSinceEpoch}',
          'name': '${p['name']} (نسخة)',
          'sku': '${p['sku']}-COPY',
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تكرار المنتج "${p['name']}" بنجاح.')),
      );
    } else if (action == 'share') {
      showModalBottomSheet(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('مشاركة المنتج', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.link, color: AppColors.primary),
                  title: Text('نسخ رابط المنتج'),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ الرابط الحافظة.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share, color: Colors.green),
                  title: Text('إرسال عبر واتساب للمصانع'),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (action == 'delete') {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('حذف المنتج', textAlign: TextAlign.right),
          content: Text('هل أنت متأكد من حذف المنتج "${p['name']}"؟ لا يمكن التراجع عن هذا الإجراء.', textAlign: TextAlign.right),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() => _allProducts.removeWhere((prod) => prod['id'] == p['id']));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف المنتج بنجاح.')),
                );
              },
              child: Text('حذف', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }
}
