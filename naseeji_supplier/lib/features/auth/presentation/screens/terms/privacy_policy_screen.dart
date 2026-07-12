import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
              _buildSection(theme, 'البيانات التي نجمعها', 'نقوم بجمع بيانات الشركة وبيانات الاتصال والملفات الثبوتية مثل السجل التجاري لتوثيق الحساب وضمان أمان التعاملات بالمنصة.'),
              _buildSection(theme, 'طريقة استخدام البيانات', 'نستخدم هذه البيانات لتسهيل المفاوضات وعرض المنتجات وتوصيل الشحنات، وتحسين خوارزميات التوفيق والذكاء الاصطناعي بالمنصة.'),
              _buildSection(theme, 'حماية البيانات', 'تخضع جميع البيانات للتشفير وتخزين آمن في قواعد بيانات محمية بالكامل لمنع أي تسريب أو وصول غير مصرح به.'),
              _buildSection(theme, 'مشاركة البيانات', 'لا نبيع ولا نشارك بياناتك الخاصة لأي أطراف خارجية إلا بموافقة صريحة منك أو لتنفيذ طلبات الشحن والتعاقدات التي تتم عبر المنصة.'),
              _buildSection(theme, 'ملفات تعريف الارتباط', 'نستخدم ملفات تعريف الارتباط وتقنيات التتبع المماثلة لتحسين تجربة تصفحك وتخصيص الخدمات والتحليلات الخاصة بمتجرك بالمنصة.'),
              _buildSection(theme, 'حقوق المستخدم', 'يحق لك في أي وقت تعديل بياناتك أو تحديثها أو تصحيح أي معلومات غير دقيقة من خلال إعدادات حسابك بالمنصة.'),
              _buildSection(theme, 'حذف الحساب', 'تتيح منصة نسيجي إمكانية طلب حذف الحساب نهائياً مع كافة البيانات المرتبطة به بتقديم طلب مباشر لمركز الدعم بالمنصة.'),
              _buildSection(theme, 'التواصل', 'لأي استفسار يخص سرية البيانات أو سياسة الخصوصية، يرجى مراسلتنا عبر البريد الإلكتروني الرسمي للمنصة: support@naseeji.com.'),
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
