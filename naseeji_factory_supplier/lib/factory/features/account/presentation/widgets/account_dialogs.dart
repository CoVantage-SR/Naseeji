import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAccountDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AlertDialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'حذف الحساب نهائياً',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      content: const Text(
        'هل أنت متأكد من رغبتك في حذف حساب المصنع نهائياً؟ سيتم إلغاء كافة الاشتراكات وسحب الصلاحيات وإزالة كافة المستندات والبيانات ذات الصلة. لا يمكن التراجع عن هذا الإجراء.',
        style: TextStyle(fontSize: 13, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('تأكيد الحذف النهائي'),
        ),
      ],
    );
  }
}

class DeactivateAccountDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeactivateAccountDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AlertDialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.pause_circle_outline_rounded, color: AppColors.warning, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'تجميد الحساب موقتاً',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
      content: const Text(
        'عند تعليق الحساب مؤقتاً لن تظهر منتجات المصنع في السوق ولن تتمكن من تقديم عروض أسعار جديدة حتى تفعيله مجدداً.',
        style: TextStyle(fontSize: 13, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('تأكيد التجميد'),
        ),
      ],
    );
  }
}

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AlertDialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      title: Text(
        'تسجيل الخروج',
        style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج من التطبيق؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('تسجيل الخروج'),
        ),
      ],
    );
  }
}

class WithdrawMoneyDialog extends StatefulWidget {
  final double currentBalance;
  final Function(double amount, String bankId) onWithdraw;

  const WithdrawMoneyDialog({
    super.key,
    required this.currentBalance,
    required this.onWithdraw,
  });

  @override
  State<WithdrawMoneyDialog> createState() => _WithdrawMoneyDialogState();
}

class _WithdrawMoneyDialogState extends State<WithdrawMoneyDialog> {
  final _amountController = TextEditingController();
  String _selectedBank = 'BA-01';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AlertDialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      title: Text(
        'سحب رصيد من المحفظة',
        style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الرصيد المتاح: ${widget.currentBalance.toInt()} ج.م',
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'المبلغ المطلوب سحبه (ج.م)',
                prefixIcon: Icon(Icons.attach_money_rounded),
              ),
            ),
            const SizedBox(height: 12),
            const Text('الحساب البنكي لتحويل المبلغ:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedBank,
              items: const [
                DropdownMenuItem(value: 'BA-01', child: Text('CIB - **** 8821')),
                DropdownMenuItem(value: 'BA-02', child: Text('بنك مصر - **** 7415')),
              ],
              onChanged: (val) => setState(() => _selectedBank = val ?? 'BA-01'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
          ),
          onPressed: () {
            final amt = double.tryParse(_amountController.text) ?? 0.0;
            if (amt > 0 && amt <= widget.currentBalance) {
              widget.onWithdraw(amt, _selectedBank);
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الرجاء إدخال مبلغ صحيح ضمن الرصيد المتاح.')),
              );
            }
          },
          child: const Text('تأكيد السحب'),
        ),
      ],
    );
  }
}

class UpgradePlanDialog extends StatelessWidget {
  final Function(String planName) onSelectPlan;

  const UpgradePlanDialog({super.key, required this.onSelectPlan});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AlertDialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      title: Text(
        'ترقية خطة الاشتراك',
        style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _planCard(
              context,
              title: 'باقة الأعمال PRO',
              price: '18,000 ج.م / سنوياً',
              desc: 'إضافة حتى 100 منتج + 10 موظفين + دعم فني مباشر',
              onTap: () {
                Navigator.pop(context);
                onSelectPlan('الأعمال PRO');
              },
            ),
            const SizedBox(height: 10),
            _planCard(
              context,
              title: 'باقة المؤسسات Enterprise',
              price: '32,000 ج.م / سنوياً',
              desc: 'منتجات غير محدودة + عدد موظفين غير محدود + مدير حساب خاص',
              isPopular: true,
              onTap: () {
                Navigator.pop(context);
                onSelectPlan('المؤسسات Enterprise');
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إغلاق')),
      ],
    );
  }

  Widget _planCard(
    BuildContext context, {
    required String title,
    required String price,
    required String desc,
    required VoidCallback onTap,
    bool isPopular = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.rMD,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: isPopular ? AppColors.primary : Colors.grey.withValues(alpha: 0.3), width: isPopular ? 1.5 : 1),
          borderRadius: AppRadius.rMD,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.rRound),
                    child: const Text('الأكثر طلباً', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(price, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class RenewPlanDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const RenewPlanDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return AlertDialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.rLG),
      title: Text(
        'تجديد الاشتراك',
        style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      content: const Text(
        'سيتم تجديد اشتراك باقة "بريميوم" لمدة سنة كاملة بقيمة 12,000 ج.م وخصمها من الرصيد المتاح في المحفظة.',
        style: TextStyle(fontSize: 13, height: 1.5),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text('تأكيد التجديد'),
        ),
      ],
    );
  }
}
