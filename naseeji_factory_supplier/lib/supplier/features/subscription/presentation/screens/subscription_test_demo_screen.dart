import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/subscription_models.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/subscription_card.dart';
import '../widgets/subscription_usage_card.dart';
import '../widgets/upgrade_dialog.dart';

class SubscriptionTestDemoScreen extends ConsumerStatefulWidget {
  const SubscriptionTestDemoScreen({super.key});

  @override
  ConsumerState<SubscriptionTestDemoScreen> createState() =>
      _SubscriptionTestDemoScreenState();
}

class _SubscriptionTestDemoScreenState
    extends ConsumerState<SubscriptionTestDemoScreen> {
  int _currentImageCount = 0;
  int _currentVideoCount = 0;
  int _currentPdfCount = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subAsync = ref.watch(activeSubscriptionControllerProvider);
    final usageAsync = ref.watch(subscriptionUsageControllerProvider);
    final validator = ref.watch(subscriptionValidationProvider.notifier);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'اختبار قيود الاشتراكات والخدمات',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'شاشة إدارة الاشتراك',
              onPressed: () => context.push('/subscription/manage'),
            ),
          ],
        ),
        body: subAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (sub) => usageAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (usage) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Header Card with Plan & Usage
                  SubscriptionCard(
                    subscription: sub,
                    usage: usage,
                    onUpgradePressed: () => context.push('/subscription/manage'),
                    onManagePressed: () => context.push('/subscription/manage'),
                  ),
                  const SizedBox(height: 20),

                  // Quick Switch Plan Buttons for interactive testing
                  Text(
                    'تبديل الباقة سريعاً للاختبار:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildPlanChip('free', 'Free (مجانية)', sub.planId),
                      _buildPlanChip('basic', 'Basic (أساسية)', sub.planId),
                      _buildPlanChip(
                          'professional', 'Professional (احترافية)', sub.planId),
                      _buildPlanChip(
                          'enterprise', 'Enterprise (غير محدودة)', sub.planId),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Detailed Usage View
                  SubscriptionUsageCard(
                    subscription: sub,
                    usage: usage,
                  ),
                  const SizedBox(height: 24),

                  // Test Action Buttons Header
                  Text(
                    'اختبار العمليات المربوطة بالاشتراك:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action 1: Add Product
                  _buildTestTile(
                    context,
                    title: '1. إضافة منتج جديد (قبل الحفظ)',
                    subtitle:
                        'الاستخدام الحالي: ${usage.productsUsed} / ${sub.limits.maxProducts == -1 ? 'غير محدود' : sub.limits.maxProducts}',
                    icon: Icons.add_shopping_cart,
                    buttonLabel: 'فحص وإضافة منتج',
                    onPressed: () {
                      final result = validator.validateAddProduct(sub, usage);
                      if (result.isAllowed) {
                        ref
                            .read(subscriptionUsageControllerProvider.notifier)
                            .incrementProducts();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ تم إضافة المنتج بنجاح!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        UpgradeDialog.show(
                          context,
                          title: result.title,
                          message: result.errorMessage,
                          onUpgrade: () => context.push('/subscription/manage'),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Action 2: Image Upload Limit
                  _buildTestTile(
                    context,
                    title: '2. رفع صورة للمنتج',
                    subtitle:
                        'عدد الصور الحالية للمنتج: $_currentImageCount (الحد: ${sub.limits.maxImagesPerProduct == -1 ? 'غير محدود' : sub.limits.maxImagesPerProduct})',
                    icon: Icons.image_outlined,
                    buttonLabel: 'فحص ورفع صورة',
                    onPressed: () {
                      final result = validator.validateAddImage(
                          sub, _currentImageCount);
                      if (result.isAllowed) {
                        setState(() {
                          _currentImageCount++;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '✓ تم رفع الصورة رقم $_currentImageCount بنجاح!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        _showWarningDialog(
                          context,
                          title: result.title ?? 'تنبيه الحد الأقصى للصور',
                          message: result.errorMessage ??
                              'وصلت للحد الأقصى لعدد الصور المسموح بها.',
                        );
                      }
                    },
                    extraWidget: TextButton(
                      onPressed: () => setState(() => _currentImageCount = 0),
                      child: const Text('إعادة ضبط الصور (0)'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action 3: Video Upload Limit
                  _buildTestTile(
                    context,
                    title: '3. رفع فيديو للمنتج',
                    subtitle:
                        'الفيديوهات الحالية: $_currentVideoCount (الحد: ${sub.limits.maxVideosPerProduct == 0 ? 'غير متاح بالباقة' : sub.limits.maxVideosPerProduct})',
                    icon: Icons.videocam_outlined,
                    buttonLabel: 'فحص ورفع فيديو',
                    onPressed: () {
                      final result = validator.validateAddVideo(
                          sub, _currentVideoCount);
                      if (result.isAllowed) {
                        setState(() {
                          _currentVideoCount++;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '✓ تم رفع الفيديو رقم $_currentVideoCount بنجاح!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        _showWarningDialog(
                          context,
                          title: result.title ?? 'ميزة غير متاحة',
                          message: result.errorMessage ??
                              'هذه الميزة متاحة في الباقات الأعلى.',
                        );
                      }
                    },
                    extraWidget: TextButton(
                      onPressed: () => setState(() => _currentVideoCount = 0),
                      child: const Text('إعادة ضبط الفيديو (0)'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action 4: PDF Upload Limit
                  _buildTestTile(
                    context,
                    title: '4. رفع ملف PDF للمنتج',
                    subtitle:
                        'ملفات PDF الحالية: $_currentPdfCount (الحد: ${sub.limits.maxPdfsPerProduct == -1 ? 'غير محدود' : sub.limits.maxPdfsPerProduct})',
                    icon: Icons.picture_as_pdf_outlined,
                    buttonLabel: 'فحص ورفع PDF',
                    onPressed: () {
                      final result =
                          validator.validateAddPdf(sub, _currentPdfCount);
                      if (result.isAllowed) {
                        setState(() {
                          _currentPdfCount++;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '✓ تم رفع ملف PDF رقم $_currentPdfCount بنجاح!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        _showWarningDialog(
                          context,
                          title: result.title ?? 'حد ملفات PDF',
                          message: result.errorMessage ??
                              'وصلت للحد الأقصى لعدد ملفات PDF.',
                        );
                      }
                    },
                    extraWidget: TextButton(
                      onPressed: () => setState(() => _currentPdfCount = 0),
                      child: const Text('إعادة ضبط PDF (0)'),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action 5: Create Ad Limit
                  _buildTestTile(
                    context,
                    title: '5. إنشاء إعلان جديد',
                    subtitle:
                        'الإعلانات الحالية: ${usage.advertisementsUsed} / ${sub.limits.maxAdvertisements == -1 ? 'غير محدود' : sub.limits.maxAdvertisements}',
                    icon: Icons.campaign_outlined,
                    buttonLabel: 'فحص وإنشاء إعلان',
                    onPressed: () {
                      final result =
                          validator.validateAddAdvertisement(sub, usage);
                      if (result.isAllowed) {
                        ref
                            .read(subscriptionUsageControllerProvider.notifier)
                            .incrementAds();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ تم إنشاء الإعلان بنجاح!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        UpgradeDialog.show(
                          context,
                          title: result.title,
                          message: result.errorMessage,
                          onUpgrade: () => context.push('/subscription/manage'),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Action 6: Submit RFQ
                  _buildTestTile(
                    context,
                    title: '6. إرسال طلب سعر (RFQ)',
                    subtitle:
                        'طلبات RFQ الشهرية: ${usage.rfqsUsed} / ${sub.limits.maxMonthlyRfqs == -1 ? 'غير محدود' : sub.limits.maxMonthlyRfqs}',
                    icon: Icons.request_quote_outlined,
                    buttonLabel: 'فحص وإرسال RFQ',
                    onPressed: () {
                      final result = validator.validateSubmitRfq(sub, usage);
                      if (result.isAllowed) {
                        ref
                            .read(subscriptionUsageControllerProvider.notifier)
                            .incrementRfqs();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ تم إرسال طلب RFQ بنجاح!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        UpgradeDialog.show(
                          context,
                          title: result.title,
                          message: result.errorMessage,
                          onUpgrade: () => context.push('/subscription/manage'),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanChip(String planId, String label, String currentPlanId) {
    final isSelected = planId == currentPlanId;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          ref
              .read(activeSubscriptionControllerProvider.notifier)
              .upgrade(planId, BillingCycle.monthly);
        }
      },
    );
  }

  Widget _buildTestTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String buttonLabel,
    required VoidCallback onPressed,
    Widget? extraWidget,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (extraWidget != null) extraWidget else const SizedBox(),
                FilledButton.tonal(
                  onPressed: onPressed,
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Text(buttonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWarningDialog(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          icon: const Icon(Icons.warning_amber_rounded,
              color: Colors.orange, size: 36),
          title: Text(title, textAlign: TextAlign.center),
          content: Text(message, textAlign: TextAlign.center),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إغلاق'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                context.push('/subscription/manage');
              },
              child: const Text('ترقية الباقة'),
            ),
          ],
        ),
      ),
    );
  }
}

