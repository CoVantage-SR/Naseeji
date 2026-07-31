import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الشروط والأحكام', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.maybeOf(context)?.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(theme, 'مقدمة', 'أهلاً بك في منصة نسيجي للتوريد. باستخدامك للمنصة، فإنك توافق على الامتثال لهذه الشروط والأحكام بالكامل.'),
              _buildSection(theme, 'استخدام المنصة', 'يجب استخدام المنصة فقط للأغراض التجارية المشروعة وبما يتوافق مع القوانين واللوائح المعمول بها في جمهورية مصر العربية.'),
              _buildSection(theme, 'شروط المورد', 'يلتزم المورد بتقديم خامات حقيقية ومطابقة للمواصفات المعروضة في حسابه وبأسعار عادلة ومناسبة للطرفين.'),
              _buildSection(theme, 'شروط المصنع', 'يلتزم المصنع بسداد الدفعات المتفق عليها للطلبات في المواعيد المحددة وعدم التلاعب بالعروض المقدمة من الموردين.'),
              _buildSection(theme, 'المنتجات', 'يجب أن تكون جميع المنتجات والخامات المدرجة بالمنصة مطابقة للمواصفات القياسية وخالية من أي عيوب تصنيع.'),
              _buildSection(theme, 'الطلبات', 'تعتبر الطلبات وعروض الأسعار ملزمة للطرفين بمجرد الموافقة عليها إلكترونياً عبر المنصة ولا يجوز إلغاؤها دون عذر مقبول.'),
              _buildSection(theme, 'الدفع', 'تتم عمليات الدفع إلكترونياً عبر بوابات الدفع المعتمدة لدى المنصة لحفظ حقوق الطرفين في حساب الضمان المؤقت.'),
              _buildSection(theme, 'الشحن', 'يتم تنسيق عمليات الشحن والتوصيل مع شركات الشحن المعتمدة لدى المنصة أو عبر النقل المباشر وتوثيق التسليم بالمنصة.'),
              _buildSection(theme, 'الإعلانات', 'تخضع المواد الإعلانية المعروضة من الموردين للمراجعة لضمان ملاءمتها ومصداقيتها وعدم تضليل العملاء.'),
              _buildSection(theme, 'الاشتراكات', 'تتوفر باقات اشتراك متنوعة للموردين بميزات مختلفة، ويتم دفع رسوم الباقة دورياً لضمان استمرارية الخدمات.'),
              _buildSection(theme, 'إيقاف الحساب', 'تحتفظ إدارة نسيجي بالحق في إيقاف أو تجميد أي حساب يخالف بنود الاتفاقية أو يمارس نشاطات احتيالية.'),
              _buildSection(theme, 'حل النزاعات', 'في حال حدوث خلاف، يتم اللجوء لمركز حل النزاعات بالمنصة للتحكيم الودي قبل اتخاذ أي إجراءات قانونية خارجها.'),
              _buildSection(theme, 'التعديلات', 'قد نقوم بتحديث الشروط والأحكام من وقت لآخر، وسيتم إخطارك بأي تعديلات هامة تطرأ على هذه الصفحة.'),
              _buildSection(theme, 'التواصل', 'إذا كان لديك أي استفسار حول الشروط والأحكام، يرجى التواصل معنا عبر مركز الدعم الفني بالمنصة.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}



