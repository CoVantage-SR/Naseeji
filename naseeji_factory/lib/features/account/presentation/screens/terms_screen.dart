import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../widgets/account_reusable_widgets.dart';
import '../widgets/terms/accept_widget.dart';
import '../widgets/terms/terms_search_widget.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  String _query = '';
  final Set<int> _expanded = {};

  static const _sections = [
    (
      'استخدام المنصة',
      'تُقدم منصة نسيجي خدماتها لأصحاب المصانع والموردين في قطاع الغزل والنسيج. باستخدامك للمنصة فإنك توافق على الالتزام بجميع الشروط والأحكام المنصوص عليها في هذه الاتفاقية. يُحظر استخدام المنصة لأغراض غير مشروعة أو مخالفة للقوانين المصرية.',
    ),
    (
      'مسؤوليات المصنع',
      'يتحمل المصنع المسؤولية الكاملة عن صحة ودقة المعلومات والمستندات المُقدَّمة. كما يلتزم المصنع بالوفاء بالطلبات في المواعيد المحددة، والحفاظ على معايير الجودة المتفق عليها مع الموردين.',
    ),
    (
      'مسؤوليات المورد',
      'يلتزم المورد بتقديم منتجات مطابقة للمواصفات المتفق عليها، وضمان سلامة الشحنات والتسليم في الوقت المحدد. أي إخلال بهذه الالتزامات قد يُعرّض المورد لإجراءات قانونية أو تعليق حسابه.',
    ),
    (
      'سياسة الدفع',
      'تُستخدم نظم الدفع الآمنة المعتمدة لجميع المعاملات المالية على المنصة. يتم الدفع وفقاً للشروط المتفق عليها في كل طلب. تحتفظ المنصة بحق خصم عمولة خدمة بنسبة محددة من كل معاملة مكتملة.',
    ),
    (
      'حل النزاعات',
      'في حالة نشوء أي نزاع بين الأطراف، يُفضَّل حلّه بالتراضي أولاً عبر آلية الوساطة المتوفرة في المنصة. وفي حال عدم التوصل إلى حل، تُطبَّق أحكام القانون المصري وتختص المحاكم المصرية بالنظر في النزاع.',
    ),
    (
      'تعليق الحساب',
      'تحتفظ المنصة بالحق في تعليق أو إنهاء أي حساب في حال ثبوت الاحتيال أو انتهاك الشروط. سيُبلَّغ صاحب الحساب مسبقاً قبل اتخاذ أي إجراء، إلا في حالات الانتهاك الجسيم.',
    ),
    (
      'الملكية الفكرية',
      'جميع المحتويات والتصميمات والعلامات التجارية المنشورة على منصة نسيجي هي ملك حصري لها ومحمية بموجب قوانين حقوق الملكية الفكرية. يُحظر نسخها أو إعادة توزيعها دون إذن كتابي مسبق.',
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
    final filtered = _filteredIndexes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الشروط والأحكام'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'مشاركة',
            onPressed: () {},
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
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TermsSearchWidget(
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                'آخر تحديث: ١ يناير ٢٠٢٦',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
            // Sections
            Expanded(
              child: filtered.isEmpty
                  ? const AccountEmptyStateWidget(
                      title: 'لا توجد نتائج',
                      description: 'جرّب كلمة بحث مختلفة.',
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
            // Accept Banner
            AcceptWidget(
              onAccept: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('شكراً على موافقتك على الشروط والأحكام.')),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
