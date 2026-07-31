import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../widgets/account_reusable_widgets.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String _query = '';
  final Set<int> _expanded = {};

  static const _sections = [
    (
      'البيانات التي نجمعها',
      'نقوم بجمع البيانات التي تقدمها طوعاً عند التسجيل مثل اسم المصنع والبريد الإلكتروني ورقم الهاتف والموقع الجغرافي. كما نجمع بيانات الاستخدام مثل الصفحات التي تزورها والطلبات التي تُنشئها وسجلات الجلسات.',
    ),
    (
      'كيف نستخدم بياناتك',
      'نستخدم البيانات المجمعة لتحسين خدماتنا وتخصيص تجربة الاستخدام، وإرسال الإشعارات المتعلقة بالطلبات والعروض، وتحليل أداء المنصة وتطوير المنتجات الجديدة.',
    ),
    (
      'مشاركة البيانات',
      'لا نبيع بياناتك الشخصية لأطراف ثالثة. قد نشارك بعض البيانات مع شركاء خدميين موثوقين لتقديم الخدمات اللازمة، وذلك وفق اتفاقيات سرية صارمة. نلتزم بالإفصاح في حالات الضرورة القانونية فقط.',
    ),
    (
      'أمان البيانات',
      'نستخدم تشفير SSL/TLS لحماية البيانات أثناء النقل. يتم تخزين البيانات على خوادم آمنة محمية بجدران حماية متقدمة. نُجري مراجعات دورية للأمان ونلتزم بمعايير ISO 27001.',
    ),
    (
      'الاحتفاظ بالبيانات',
      'نحتفظ ببياناتك طوال فترة نشاط حسابك. بعد إغلاق الحساب، نحتفظ بالبيانات لمدة ٩٠ يوماً لأغراض قانونية وتدقيقية قبل حذفها نهائياً. يمكنك طلب حذف بياناتك في أي وقت.',
    ),
    (
      'حقوقك',
      'يحق لك الوصول إلى بياناتك الشخصية وتصحيحها أو حذفها في أي وقت. يمكنك طلب نسخة من بياناتك أو سحب موافقتك على معالجتها. للتواصل حول حقوقك يرجى مراسلتنا عبر privacy@naseeji.com.',
    ),
    (
      'سياسة الكوكيز',
      'نستخدم ملفات الكوكيز لتحسين تجربة الاستخدام وتحليل حركة الزيارات. يمكنك ضبط متصفحك لرفض الكوكيز، لكن هذا قد يؤثر على بعض وظائف المنصة.',
    ),
    (
      'معلومات التواصل',
      'للتواصل مع فريق الخصوصية لدينا: البريد الإلكتروني: privacy@naseeji.com، رقم الهاتف: +20 2 1234 5678، العنوان: المنطقة الصناعية، المحلة الكبرى، الغربية، مصر.',
    ),
  ];

  List<int> get _filteredIndexes {
    if (_query.isEmpty) return List.generate(_sections.length, (i) => i);
    return List.generate(_sections.length, (i) => i)
        .where((i) =>
            _sections[i].$1.contains(_query) || _sections[i].$2.contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final filtered = _filteredIndexes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {},
            tooltip: 'مشاركة',
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded),
            tooltip: 'نسخ',
            onPressed: () {
              final text = _sections.map((s) => '${s.$1}\n${s.$2}').join('\n\n');
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم النسخ!')));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'البحث في سياسة الخصوصية...',
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.grey),
                  border: OutlineInputBorder(borderRadius: AppRadius.rMD),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                'آخر تحديث: ١ يناير ٢٠٢٦',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const AccountEmptyStateWidget(
                      title: 'لا توجد نتائج',
                      description: 'جرّب كلمة بحث أخرى.',
                      icon: Icons.search_off_rounded,
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final idx = filtered[i];
                        final sec = _sections[idx];
                        final isExp = _expanded.contains(idx);
                        return SectionCard(
                          title: '${idx + 1}. ${sec.$1}',
                          content: sec.$2,
                          isExpanded: isExp,
                          onToggle: () {
                            setState(() {
                              if (isExp) {
                                _expanded.remove(idx);
                              } else {
                                _expanded.add(idx);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
            // Contact section at bottom
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0D1B2A) : const Color(0xFFEFF6FF),
                border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: AppRadius.rSM,
                    ),
                    child: const Icon(Icons.support_agent_rounded, color: AppColors.info, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('للاستفسارات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('privacy@naseeji.com', style: TextStyle(fontSize: 11, color: AppColors.info)),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                    ),
                    child: const Text('تواصل', style: TextStyle(fontSize: 12)),
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



