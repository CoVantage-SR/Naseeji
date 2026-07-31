import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز المساعدة والتعلم'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'الأسئلة الشائعة FAQ'),
            Tab(text: 'الفيديوهات والوثائق'),
            Tab(text: 'الاقتراحات والبلاغات'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: FAQ
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _faqItem(
                context,
                question: 'كيف يمكنني تقديم عرض سعر RFQ للموردين؟',
                answer: 'يمكنك الانتقال إلى تبويب طلبات الأسعار (RFQ) والضغط على "إنشاء طلب جديد"، وتحديد الكميات والأواصفات المطلوبة ليصل إلى الموردين المعتمدين.',
              ),
              _faqItem(
                context,
                question: 'ما هي طرق السحب المتاحة في المحفظة؟',
                answer: 'يدعم التطبيق التحويل البنكي المباشر على كافة البنوك المصرية (مثل CIB، بنك مصر، الأهلي) بالإضافة لشبكة انستا باي Instapay.',
              ),
              _faqItem(
                context,
                question: 'كيف يمكن إضافة موظفين وتحديد صلاحياتهم؟',
                answer: 'من قسم "إدارة الموظفين" في قائمة الحساب، اضغط على زر الإضافة وادخل بيانات الموظف ثم اختر الدور والصلاحيات المحددة له.',
              ),
              _faqItem(
                context,
                question: 'ما هو إجراء توثيق حساب المصنع؟',
                answer: 'يتم التوثيق برفع السجل التجاري والبطاقة الضريبية والتراخيص الصناعية ليتولى فريق نسيجي مراجعتها ومنح شارة "مصنع موثق".',
              ),
            ],
          ),

          // Tab 2: Video Tutorials & Documentation
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('الشروحات والدروس التفاعلية', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              _videoTutorialCard(
                context,
                title: 'دليل البدء السريع وإدارة ملف المصنع',
                duration: '4:15 دقيقة',
              ),
              _videoTutorialCard(
                context,
                title: 'كيفية متابعة صفقات التوريد ومراحل الإنتاج',
                duration: '6:30 دقيقة',
              ),
              const SizedBox(height: 20),
              Text('الوثائق والشروط القانونية', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rLG, border: Border.all(color: border)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.gavel_rounded, color: AppColors.primary),
                      title: const Text('الشروط والأحكام الاستخدام'),
                      trailing: const Icon(Icons.chevron_left_rounded),
                      onTap: () => context.push('/account/terms'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_rounded, color: AppColors.primary),
                      title: const Text('سياسة الخصوصية وحماية البيانات'),
                      trailing: const Icon(Icons.chevron_left_rounded),
                      onTap: () => context.push('/account/privacy'),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Tab 3: Suggestions & Bug Report
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _actionCard(
                context,
                icon: Icons.lightbulb_outline_rounded,
                title: 'تقديم اقتراح لتطوير المنصة',
                desc: 'شاركونا أفكاركم ومقترحاتكم لتحسين منصة نسيجي.',
                buttonText: 'إرسال اقتراح',
                onTap: () => _showSuggestionDialog(context),
              ),
              const SizedBox(height: 14),
              _actionCard(
                context,
                icon: Icons.bug_report_outlined,
                title: 'الإبلاغ عن مشكلة أو خطأ برمجي',
                desc: 'في حال واجهتكم أي مشكلة تقنية، يرجى إرسال تقرير فوري.',
                buttonText: 'إرسال بلاغ',
                onTap: () => _showBugReportDialog(context),
              ),
              const SizedBox(height: 14),
              _actionCard(
                context,
                icon: Icons.headset_mic_outlined,
                title: 'التواصل المباشر مع الدعم الفني',
                desc: 'فريق الدعم الفني متواجد على مدار الساعة لمساعدتكم.',
                buttonText: 'الانتقال للدعم الفني',
                onTap: () => context.push('/account/support'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _faqItem(BuildContext context, {required String question, required String answer}) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rMD, border: Border.all(color: border)),
      child: ExpansionTile(
        title: Text(question, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(answer, style: const TextStyle(fontSize: 12, height: 1.5, color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _videoTutorialCard(BuildContext context, {required String title, required String duration}) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rMD, border: Border.all(color: border)),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.rSM),
            child: const Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text('المدة: $duration', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, size: 20),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('جاري تشغيل الفيديو التعليمي...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String desc,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: surface, borderRadius: AppRadius.rLG, border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
              ),
              onPressed: onTap,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuggestionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تقديم اقتراح'),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(hintText: 'اكتب اقتراحك هنا بكامل التفاصيل...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('شكراً لك! تم استلام اقتراحك بنجاح.')),
              );
            },
            child: const Text('إرسال'),
          ),
        ],
      ),
    );
  }

  void _showBugReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('الإبلاغ عن مشكلة تقنية'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: 'عنوان المشكلة')),
            SizedBox(height: 10),
            TextField(maxLines: 3, decoration: InputDecoration(labelText: 'وصف المشكلة وكيفية حدوثها')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال التقرير لفريق التطوير بنجاح.')),
              );
            },
            child: const Text('إرسال التقرير'),
          ),
        ],
      ),
    );
  }
}
