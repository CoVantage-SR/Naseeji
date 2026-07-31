// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/core/widgets/general_widgets.dart';
import '../controllers/financial_controllers.dart';

class RequestWithdrawalScreen extends ConsumerStatefulWidget {
  const RequestWithdrawalScreen({super.key});

  @override
  ConsumerState<RequestWithdrawalScreen> createState() => _RequestWithdrawalScreenState();
}

class _RequestWithdrawalScreenState extends ConsumerState<RequestWithdrawalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _bankController = TextEditingController(text: 'مصرف الراجحي');
  final _ibanController = TextEditingController(text: 'SA8080000000012345678902');
  final _holderController = TextEditingController(text: 'مؤسسة نسيج الوطن للتجارة');
  final _notesController = TextEditingController();

  String _selectedMethod = 'تحويل بنكي';
  final List<String> _methods = ['تحويل بنكي', 'InstaPay', 'محفظة رقمية (STC Pay)', 'تحويل يدوي'];

  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _bankController.dispose();
    _ibanController.dispose();
    _holderController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletAsync = ref.watch(financialWalletControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'طلب سحب رصيد',
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
        child: walletAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (wallet) {
            final available = wallet.availableBalance;
            const minWithdrawal = 1000.0;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Available balance summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'الرصيد المتاح للسحب حالياً',
                            style: TextStyle(fontSize: 12, color: AppColors.outline),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${available.toStringAsFixed(2)} جنيه',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'الحد الأدنى للسحب: 1,000.00 جنيه',
                            style: TextStyle(fontSize: 10, color: AppColors.outline),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Method selector
                    Text(
                      'اختر طريقة السحب',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedMethod,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.outlineVariant),
                        ),
                      ),
                      items: _methods.map((method) {
                        return DropdownMenuItem(
                          value: method,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(method),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _selectedMethod = val;
                            if (val == 'InstaPay') {
                              _bankController.text = 'InstaPay Wallet';
                              _ibanController.text = 'naseeji@instapay';
                            } else if (val == 'محفظة رقمية (STC Pay)') {
                              _bankController.text = 'STC Pay';
                              _ibanController.text = '0555555555';
                            } else {
                              _bankController.text = 'مصرف الراجحي';
                              _ibanController.text = 'SA8080000000012345678902';
                            }
                          });
                        }
                      },
                    ),
                    SizedBox(height: 16),

                    // Amount input
                    Text(
                      'المبلغ المطلوب سحبه (جنيه)',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: _amountController,
                      labelText: 'المبلغ',
                      hintText: 'أدخل قيمة بين 1000 و ${available.toStringAsFixed(0)}',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'يرجى إدخال المبلغ';
                        final double? amt = double.tryParse(val);
                        if (amt == null) return 'يرجى إدخال رقم صحيح';
                        if (amt < minWithdrawal) return 'المبلغ أقل من الحد الأدنى المسموح به ($minWithdrawal جنيه)';
                        if (amt > available) return 'المبلغ المطلوب أكبر من الرصيد المتاح حالياً ($available جنيه)';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Account holder input
                    Text(
                      'اسم صاحب الحساب المستفيد',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: _holderController,
                      labelText: 'صاحب الحساب',
                      validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال اسم المستفيد' : null,
                    ),
                    SizedBox(height: 16),

                    // Bank name / wallet identifier
                    Text(
                      _selectedMethod.contains('بنكي') ? 'اسم البنك' : 'جهة المحفظة',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: _bankController,
                      labelText: _selectedMethod.contains('بنكي') ? 'البنك' : 'الجهة',
                      validator: (val) => val == null || val.isEmpty ? 'يرجى ملء الحقل' : null,
                    ),
                    SizedBox(height: 16),

                    // IBAN / wallet details
                    Text(
                      _selectedMethod.contains('بنكي') ? 'رقم الآيبان (IBAN)' : 'معرف المحفظة / الرقم',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: _ibanController,
                      labelText: _selectedMethod.contains('بنكي') ? 'الآيبان' : 'المعرف',
                      validator: (val) => val == null || val.isEmpty ? 'يرجى كتابة رقم الحساب أو المحفظة' : null,
                    ),
                    SizedBox(height: 16),

                    // Notes
                    Text(
                      'ملاحظات إضافية (اختياري)',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 8),
                    CustomTextField(
                      controller: _notesController,
                      labelText: 'ملاحظات',
                      maxLines: 2,
                    ),
                    SizedBox(height: 24),

                    // Submit button
                    PrimaryButton(
                      text: 'إرسال طلب السحب',
                      isLoading: _isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          try {
                            final amt = double.parse(_amountController.text);
                            await ref.read(financialWithdrawalsControllerProvider.notifier).requestWithdrawal(
                                  method: _selectedMethod,
                                  amount: amt,
                                  bankName: _bankController.text,
                                  iban: _ibanController.text,
                                  accountHolder: _holderController.text,
                                  notes: _notesController.text,
                                );
                            
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('تم تسجيل طلب السحب بنجاح وقيد المعالجة الماليّة.')),
                              );
                              context.pop();
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('فشل طلب السحب: $e')),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}