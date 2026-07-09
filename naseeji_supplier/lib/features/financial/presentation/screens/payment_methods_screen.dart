import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/financial_controllers.dart';
import '../../domain/entities/financial_models.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bankController = TextEditingController();
  final _holderController = TextEditingController();
  final _identifierController = TextEditingController();

  String _selectedType = 'bank_account';
  bool _isAdding = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bankController.dispose();
    _holderController.dispose();
    _identifierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(financialPaymentMethodsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إدارة الحسابات البنكيّة ووسائل الدفع',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: methodsAsync.when(
                loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
                error: (err, stack) => Center(child: Text('خطأ: $err')),
                data: (methods) {
                  if (methods.isEmpty) {
                    return Center(child: Text('لا توجد وسائل سداد مضافة'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: methods.length,
                    itemBuilder: (context, index) {
                      final method = methods[index];

                      return Card(
                        color: Theme.of(context).colorScheme.surface,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: method.isDefault
                                ? AppColors.primary
                                : AppColors.outlineVariant.withValues(alpha: 0.3),
                            width: method.isDefault ? 1.5 : 1.0,
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  if (method.isDefault)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'الافتراضي',
                                        style: TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  const Spacer(),
                                  Text(
                                    method.title,
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(_iconFor(method.type), color: AppColors.primary, size: 20),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'صاحب الحساب: ${method.accountHolder}',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 12, color: AppColors.outline),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'الآيبان / المعرف: ${method.identifier}',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 11, color: AppColors.outline),
                              ),
                              SizedBox(height: 12),
                              const Divider(height: 1, color: AppColors.outlineVariant),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, color: Color(0xFFBA1A1A), size: 18),
                                        onPressed: () => _deleteMethod(method.id),
                                      ),
                                      if (!method.isVerified)
                                        TextButton(
                                          onPressed: () => _verifyMethod(method.id),
                                          child: Text('تفعيل وتأكيد', style: TextStyle(color: Color(0xFFB17000), fontSize: 11, fontWeight: FontWeight.bold)),
                                        )
                                      else
                                        Row(
                                          children: [
                                            Text('حساب موثق', style: TextStyle(color: Color(0xFF00875A), fontSize: 11, fontWeight: FontWeight.bold)),
                                            SizedBox(width: 4),
                                            Icon(Icons.verified, color: Color(0xFF00875A), size: 14),
                                          ],
                                        ),
                                    ],
                                  ),
                                  if (!method.isDefault)
                                    TextButton(
                                      onPressed: () => _setDefault(method.id),
                                      child: Text('تعيين كافتراضي', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                                    )
                                  else
                                    const SizedBox.shrink(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                text: 'إضافة وسيلة دفع جديدة',
                onPressed: () => setState(() => _isAdding = true),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: _isAdding ? _buildAddMethodSheet() : null,
    );
  }

  Widget _buildAddMethodSheet() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _isAdding = false),
                  ),
                  Text(
                    'إضافة وسيلة دفع جديدة',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'نوع القناة الماليّة'),
                items: const [
                  DropdownMenuItem(value: 'bank_account', child: Align(alignment: Alignment.centerRight, child: Text('حساب بنكي تجاري'))),
                  DropdownMenuItem(value: 'instapay', child: Align(alignment: Alignment.centerRight, child: Text('InstaPay Wallet'))),
                  DropdownMenuItem(value: 'digital_wallet', child: Align(alignment: Alignment.centerRight, child: Text('محفظة جوال رقمية'))),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _titleController,
                labelText: 'تسمية الحساب (مثال: حساب الشركة الرئيسي)',
                validator: (val) => val == null || val.isEmpty ? 'يرجى كتابة تسمية' : null,
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _bankController,
                labelText: 'اسم البنك أو جهة المحفظة',
                validator: (val) => val == null || val.isEmpty ? 'يرجى ملء الحقل' : null,
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _holderController,
                labelText: 'اسم صاحب الحساب المستفيد بالكامل',
                validator: (val) => val == null || val.isEmpty ? 'يرجى كتابة الاسم' : null,
              ),
              SizedBox(height: 12),
              CustomTextField(
                controller: _identifierController,
                labelText: 'رقم الآيبان (IBAN) أو رقم الهاتف للمحفظة',
                validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال البيانات الماليّة' : null,
              ),
              SizedBox(height: 16),
              PrimaryButton(
                text: 'تأكيد الحفظ والإضافة',
                onPressed: _submitMethod,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitMethod() async {
    if (_formKey.currentState!.validate()) {
      final method = PaymentMethod(
        id: '',
        type: _selectedType,
        title: _titleController.text,
        subtitle: _bankController.text,
        accountHolder: _holderController.text,
        identifier: _identifierController.text,
        isDefault: false,
        isVerified: false,
      );

      await ref.read(financialPaymentMethodsControllerProvider.notifier).addMethod(method);
      setState(() {
        _isAdding = false;
        _titleController.clear();
        _bankController.clear();
        _holderController.clear();
        _identifierController.clear();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تمت إضافة القناة الماليّة الجديدة بنجاح.')),
        );
      }
    }
  }

  Future<void> _deleteMethod(String id) async {
    await ref.read(financialPaymentMethodsControllerProvider.notifier).deleteMethod(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف وسيلة الدفع من قائمتك.')),
      );
    }
  }

  Future<void> _setDefault(String id) async {
    await ref.read(financialPaymentMethodsControllerProvider.notifier).setDefault(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تعيين القناة كحساب افتراضي للاستلام.')),
      );
    }
  }

  Future<void> _verifyMethod(String id) async {
    await ref.read(financialPaymentMethodsControllerProvider.notifier).verifyMethod(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم توثيق الحساب البنكي وتفعيله بنجاح.')),
      );
    }
  }

  IconData _iconFor(String type) {
    switch (type) {
      case 'bank_account':
        return Icons.account_balance;
      case 'instapay':
        return Icons.send_and_archive;
      case 'digital_wallet':
        return Icons.phone_android;
      default:
        return Icons.credit_card;
    }
  }
}