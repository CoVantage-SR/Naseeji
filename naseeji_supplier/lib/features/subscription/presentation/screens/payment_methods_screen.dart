import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import '../controllers/subscription_controllers.dart';
import '../../domain/entities/subscription_models.dart';

class SubscriptionPaymentMethodsScreen extends ConsumerStatefulWidget {
  const SubscriptionPaymentMethodsScreen({super.key});

  @override
  ConsumerState<SubscriptionPaymentMethodsScreen> createState() => _SubscriptionPaymentMethodsScreenState();
}

class _SubscriptionPaymentMethodsScreenState extends ConsumerState<SubscriptionPaymentMethodsScreen> {
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  PaymentMethodType _selectedType = PaymentMethodType.creditCard;

  @override
  void dispose() {
    _nameController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _addMethod() {
    if (_nameController.text.isEmpty || _detailsController.text.isEmpty) return;

    final method = PaymentMethodItem(
      id: 'PM-${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType,
      name: _nameController.text,
      details: _detailsController.text,
      isDefault: false,
      isVerified: true,
    );

    ref.read(paymentMethodsControllerProvider.notifier).addMethod(method);

    _nameController.clear();
    _detailsController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تمت إضافة طريقة الدفع الجديدة بنجاح!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final methodsAsync = ref.watch(paymentMethodsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'طرق وبوابات الدفع',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: methodsAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (methods) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Payment methods lists
                    Text(
                      'وسائل الدفع المسجلة الحالية',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 12),
                    ...methods.map((method) {
                      IconData icon = Icons.credit_card;
                      if (method.type == PaymentMethodType.bankTransfer) {
                        icon = Icons.account_balance;
                      } else if (method.type == PaymentMethodType.instaPay) {
                        icon = Icons.bolt;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: method.isDefault
                                ? const Color(0xFF0040E0)
                                : AppColors.outlineVariant.withValues(alpha: 0.3),
                            width: method.isDefault ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PopupMenuButton<String>(
                              onSelected: (action) {
                                if (action == 'default') {
                                  ref.read(paymentMethodsControllerProvider.notifier).setDefault(method.id);
                                } else if (action == 'delete') {
                                  ref.read(paymentMethodsControllerProvider.notifier).deleteMethod(method.id);
                                }
                              },
                              itemBuilder: (ctx) => [
                                const PopupMenuItem(value: 'default', child: Text('تعيين كافتراضي', style: TextStyle(fontSize: 12))),
                                const PopupMenuItem(value: 'delete', child: Text('حذف طريقة الدفع', style: TextStyle(fontSize: 12, color: Colors.red))),
                              ],
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            if (method.isDefault)
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                margin: const EdgeInsets.only(right: 8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF006B5F).withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text('افتراضية', style: TextStyle(fontSize: 8, color: Color(0xFF006B5F), fontWeight: FontWeight.bold)),
                                              ),
                                            Text(
                                              method.name,
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          method.details,
                                          style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0040E0).withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(icon, color: const Color(0xFF0040E0), size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 24),

                    // Add Payment method form
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'إضافة طريقة دفع جديدة B2B',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          ),
                          const Divider(height: 20, color: AppColors.outlineVariant),
                          
                          Text('نوع طريقة الدفع', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          SizedBox(height: 6),
                          DropdownButtonFormField<PaymentMethodType>(
                            value: _selectedType,
                            items: const [
                              DropdownMenuItem(value: PaymentMethodType.creditCard, child: Text('بطاقة ائتمانية / مدى', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: PaymentMethodType.bankTransfer, child: Text('تحويل بنكي رسمي للمؤسسة', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: PaymentMethodType.instaPay, child: Text('حساب InstaPay سريع', style: TextStyle(fontSize: 12))),
                              DropdownMenuItem(value: PaymentMethodType.digitalWallet, child: Text('محفظة رقمية للمنشأة', style: TextStyle(fontSize: 12))),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedType = val);
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 12),
                          CustomTextField(
                            controller: _nameController,
                            labelText: 'اسم طريقة الدفع',
                            hintText: 'مثال: مدى بنك الإنماء للشركة',
                          ),
                          SizedBox(height: 12),
                          CustomTextField(
                            controller: _detailsController,
                            labelText: 'تفاصيل الحساب / أرقام البطاقة',
                            hintText: 'مثال: **** 4930 أو الآيبان SA...',
                          ),
                          SizedBox(height: 20),
                          PrimaryButton(
                            text: 'حفظ طريقة الدفع الجديدة',
                            onPressed: _addMethod,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
