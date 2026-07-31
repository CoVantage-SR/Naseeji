import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/registration_provider.dart';
import '../widgets/reusable_registration_widgets.dart' hide BackButton;
import '../widgets/reusable_registration_widgets.dart' as reg_widgets;

class BusinessCategoriesScreen extends ConsumerWidget {
  const BusinessCategoriesScreen({super.key});

  final List<Map<String, String>> _categories = const [
    {'key': 'ready_wear', 'emoji': '👕', 'title': 'ملابس جاهزة'},
    {'key': 'mens_wear', 'emoji': '👔', 'title': 'ملابس رجالي'},
    {'key': 'womens_wear', 'emoji': '👗', 'title': 'ملابس حريمي'},
    {'key': 'kids_wear', 'emoji': '👶', 'title': 'ملابس أطفال'},
    {'key': 'underwear', 'emoji': '🩳', 'title': 'ملابس داخلية'},
    {'key': 'sports_wear', 'emoji': '🥋', 'title': 'ملابس رياضية'},
    {'key': 'fabrics', 'emoji': '🧵', 'title': 'أقمشة'},
    {'key': 'yarn_threads', 'emoji': '🧶', 'title': 'غزل وخيوط'},
    {'key': 'furnishings', 'emoji': '🛏️', 'title': 'مفروشات'},
    {'key': 'bags', 'emoji': '🎒', 'title': 'حقائب'},
    {'key': 'shoes', 'emoji': '👟', 'title': 'أحذية'},
    {'key': 'socks', 'emoji': '🧦', 'title': 'جوارب'},
    {'key': 'accessories', 'emoji': '🧷', 'title': 'إكسسوارات ملابس'},
    {'key': 'printing', 'emoji': '🎨', 'title': 'طباعة'},
    {'key': 'embroidery', 'emoji': '🪡', 'title': 'تطريز'},
    {'key': 'packaging', 'emoji': '📦', 'title': 'تغليف'},
    {'key': 'bags_boxes', 'emoji': '🛍️', 'title': 'أكياس وكرتون'},
    {'key': 'machinery', 'emoji': '⚙️', 'title': 'ماكينات'},
    {'key': 'chemicals', 'emoji': '🧪', 'title': 'كيماويات'},
    {'key': 'factory_supplies', 'emoji': '🧵', 'title': 'مستلزمات مصانع'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regState = ref.watch(registrationProvider);
    final selectedKeys = regState.selectedBusinessCategories;
    final hasSelection = selectedKeys.isNotEmpty;

    void toggleCategory(String key) {
      final current = List<String>.from(selectedKeys);
      if (current.contains(key)) {
        current.remove(key);
      } else {
        current.add(key);
      }
      ref.read(registrationProvider.notifier).updateBusinessCategories(current);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RegistrationProgress(currentStep: 3, totalSteps: 4),
                    AppSpacing.hLG,
                    const RegistrationHeader(
                      title: 'مجال عمل المصنع',
                      subtitle: 'اختر المجالات اللي مصنعك بيشتغل فيها.',
                    ),
                    AppSpacing.hMD,
                    SelectionCounter(count: selectedKeys.length),
                    AppSpacing.hLG,
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context
                            .responsiveValue(mobile: 2, tablet: 4, desktop: 5)
                            .toInt(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final isSelected = selectedKeys.contains(cat['key']);

                        return BusinessCategoryCard(
                          title: cat['title']!,
                          emoji: cat['emoji']!,
                          isSelected: isSelected,
                          onTap: () => toggleCategory(cat['key']!),
                        );
                      },
                    ),
                    AppSpacing.hXL,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: reg_widgets.BackButton(
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ContinueButton(
                      onPressed: hasSelection
                          ? () => context.push('/factory-info')
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
