import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/general_widgets.dart';
import '../../../shared/enums/user_role.dart';

class TermsAcceptanceScreen extends ConsumerStatefulWidget {
  final UserRole role;

  const TermsAcceptanceScreen({
    super.key,
    required this.role,
  });

  @override
  ConsumerState<TermsAcceptanceScreen> createState() => _TermsAcceptanceScreenState();
}

class _TermsAcceptanceScreenState extends ConsumerState<TermsAcceptanceScreen> {
  bool _isAccepted = false;
  bool _isLoading = false;

  Future<void> _handleAccept() async {
    if (!_isAccepted) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إنشاء الحساب والموافقة على الشروط بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.role == UserRole.supplier) {
        context.go(AppRoutes.supplierDashboard);
      } else {
        context.go(AppRoutes.factoryHome);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'الشروط والأحكام',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: LoadingOverlay(
        isLoading: _isLoading,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainerHighest
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? colorScheme.outline : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اتفاقية الاستخدام والشروط العامة لمنصة نسيجي',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'أهلاً بك في منصة نسيجي. باستخدامك للمنصة، فإنك توافق على الالتزام بالشروط والأحكام التالية:',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          _buildSectionTitle('1. صحة البيانات والمسؤولية القانونية'),
                          _buildSectionText(
                              'يتعهد المستخدم بصحة كافة البيانات المدخلة بما في ذلك اسم الشركة، رقم السجل التجاري، ورقم البطاقة الضريبية. تتحمل الشركة كافة التبعات القانونية عن أي بيانات غير صحيحة.'),
                          const SizedBox(height: 12),
                          _buildSectionTitle('2. سرية الحساب والبيانات'),
                          _buildSectionText(
                              'يلتزم المستخدم بالحفاظ على سرية بيانات تسجيل الدخول وعدم مشاركتها مع أي أطراف غير مصرح لها. المنصة غير مسؤولة عن أي استخدام غير مصرح به ناتج عن إهمال المستخدم.'),
                          const SizedBox(height: 12),
                          _buildSectionTitle('3. التزامات التعامل والمعاملات التجارية'),
                          _buildSectionText(
                              'تلتزم المصانع والموردون بمعايير الشفافية والأمانة التجارية في العروض، وطلب طلبات التسعير (RFQ)، والالتزام بالمواصفات المحددة في العقود والصفقات المنفذة عبر المنصة.'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: _isAccepted,
                  onChanged: (val) {
                    setState(() {
                      _isAccepted = val ?? false;
                    });
                  },
                  activeColor: colorScheme.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'أقر بأني قرأت وأوافق على جميع الشروط والأحكام وسياسة الخصوصية الخاصين بـ منصة نسيجي',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'إنهاء وتأكيد إنشاء الحساب',
                  onPressed: _isAccepted ? _handleAccept : null,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildSectionText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, height: 1.5),
      ),
    );
  }
}
