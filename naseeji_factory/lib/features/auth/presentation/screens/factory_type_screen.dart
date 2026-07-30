import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../providers/registration_provider.dart';
import '../widgets/reusable_registration_widgets.dart' hide BackButton;

class FactoryTypeScreen extends ConsumerWidget {
  const FactoryTypeScreen({super.key});

  final List<Map<String, String>> _options = const [
    {
      'key': 'factory',
      'emoji': '🏭',
      'title': 'مصنع',
      'description': 'منشأة متخصصة في تصنيع وإنتاج المنتجات.',
    },
    {
      'key': 'company',
      'emoji': '🏢',
      'title': 'شركة',
      'description': 'كيان تجاري أو صناعي مسجل رسمياً لإدارة الأعمال.',
    },
    {
      'key': 'institution',
      'emoji': '🏬',
      'title': 'مؤسسة',
      'description': 'نشاط تجاري فردي أو جماعي يقدم خدمات أو منتجات.',
    },
    {
      'key': 'workshop',
      'emoji': '🏪',
      'title': 'ورشة تصنيع',
      'description': 'منشأة صغيرة مخصصة للتصنيع اليدوي أو الميكانيكي البسيط.',
    },
    {
      'key': 'importer',
      'emoji': '🌍',
      'title': 'مستورد',
      'description': 'يقوم بجلب المنتجات والخامات من خارج البلاد وتوريدها.',
    },
    {
      'key': 'distributor',
      'emoji': '📦',
      'title': 'موزع',
      'description': 'يقوم بنقل وتوزيع المنتجات من المصانع إلى منافذ البيع.',
    },
    {
      'key': 'wholesaler',
      'emoji': '🛒',
      'title': 'تاجر جملة',
      'description': 'بيع المنتجات بكميات كبيرة للموزعين والتجار الآخرين.',
    },
    {
      'key': 'retailer',
      'emoji': '🛍️',
      'title': 'تاجر تجزئة',
      'description': 'بيع المنتجات مباشرة للمستهلك النهائي عبر المحلات أو الإنترنت.',
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regState = ref.watch(registrationProvider);
    final hasSelection = regState.selectedFactoryType.isNotEmpty;

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
                    const RegistrationProgress(currentStep: 2, totalSteps: 4),
                    AppSpacing.hLG,
                    const RegistrationHeader(
                      title: 'نوع المنشأة',
                      subtitle: 'اختر نوع المنشأة اللي بتمثل نشاطك.',
                    ),
                    AppSpacing.hXL,
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      separatorBuilder: (context, index) => AppSpacing.hMD,
                      itemBuilder: (context, index) {
                        final option = _options[index];
                        final isSelected = regState.selectedFactoryType == option['key'];

                        return EstablishmentTypeCard(
                          title: option['title']!,
                          description: option['description']!,
                          emoji: option['emoji']!,
                          isSelected: isSelected,
                          onTap: () {
                            ref
                                .read(registrationProvider.notifier)
                                .updateFactoryType(option['key']!);
                          },
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
              child: ContinueButton(
                onPressed: hasSelection
                    ? () => context.push('/business-categories')
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
