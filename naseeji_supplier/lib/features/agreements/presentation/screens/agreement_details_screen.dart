import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';
import '../controllers/agreements_controller.dart';
import '../widgets/agreement_status_card.dart';
import '../widgets/agreement_progress_widget.dart';
import '../widgets/agreement_action_buttons.dart';

class AgreementDetailsScreen extends ConsumerWidget {
  final String agreementId;

  const AgreementDetailsScreen({super.key, required this.agreementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(agreementsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: stateAsync.when(
        loading: () => Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary))),
        error: (e, _) => Scaffold(body: Center(child: Text('خطأ: $e'))),
        data: (agreements) {
          final agreementIndex = agreements.indexWhere((a) => a.id == agreementId);
          if (agreementIndex == -1) {
            return Scaffold(body: Center(child: Text('الاتفاقية غير موجودة')));
          }
          final a = agreements[agreementIndex];

          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 0.5,
              centerTitle: true,
              title: Column(
                children: [
                  Text(
                    'تفاصيل الاتفاقية والعقد ${a.id}',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'طلب: ${a.orderNumber} • RFQ: ${a.rfqNumber}',
                    style: TextStyle(color: AppColors.outline, fontSize: 9),
                  ),
                ],
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // 1. Status and Progression Cards
                AgreementStatusCard(agreement: a),
                SizedBox(height: 12),
                AgreementProgressWidget(agreement: a),
                SizedBox(height: 16),

                // Navigation Shortcuts to associated sub-modules
                _buildNavigationRow(context, a),
                SizedBox(height: 16),

                // 2. Agreement Metadata
                _buildSectionCard(
                  title: 'معلومات العقد الأساسية',
                  icon: Icons.info_outline,
                  children: [
                    _buildDetailRow('رقم الاتفاقية الموحد', a.id),
                    _buildDetailRow('نوع الاتفاقية', a.type),
                    _buildDetailRow('الإصدار الحالي للاتفاقية', 'v${a.version}', isBold: true),
                    _buildDetailRow('تاريخ إنشاء العقد', a.createdDate),
                    _buildDetailRow('تاريخ آخر تحديث وأرشفة', a.lastUpdated),
                    _buildDetailRow('تاريخ انتهاء صلاحية العقد', a.expirationDate),
                  ],
                ),
                SizedBox(height: 16),

                // 3. Supplier Details
                _buildSectionCard(
                  title: 'بيانات الطرف الأول (المورد)',
                  icon: Icons.business_outlined,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(a.supplierInfo.logoBgColorValue),
                          child: Text(a.supplierInfo.logoText, style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(a.supplierInfo.companyName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                  if (a.supplierInfo.verified) ...[
                                    SizedBox(width: 4),
                                    const Icon(Icons.verified, color: Colors.blue, size: 14),
                                  ],
                                ],
                              ),
                              Text('الممثل: ${a.supplierInfo.supplierName} • تقييم المورد: ${a.supplierInfo.rating} ★', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    _buildDetailRow('هاتف المورد', a.supplierInfo.phone),
                    _buildDetailRow('البريد الإلكتروني للشركة', a.supplierInfo.email),
                    _buildDetailRow('عنوان المستودع والإنتاج', a.supplierInfo.address),
                  ],
                ),
                SizedBox(height: 16),

                // 4. Factory Details
                _buildSectionCard(
                  title: 'بيانات الطرف الثاني (المشتري والمصنع)',
                  icon: Icons.store_outlined,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(a.factoryInfo.logoBgColorValue),
                          child: Text(a.factoryInfo.logoText, style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.factoryInfo.factoryName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('الممثل المعتمد: ${a.factoryInfo.contactPerson} • تقييم المشتري: ${a.factoryInfo.rating} ★', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    _buildDetailRow('هاتف المصنع', a.factoryInfo.phone),
                    _buildDetailRow('البريد الإلكتروني للمصنع', a.factoryInfo.email),
                    _buildDetailRow('عنوان تسليم المستودع للمشتري', a.factoryInfo.address),
                  ],
                ),
                SizedBox(height: 16),

                // 5. Products Specifications
                _buildSectionCard(
                  title: 'تفاصيل المنتجات والمواصفات المعتمدة',
                  icon: Icons.category_outlined,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: NetworkImage(a.product.imageUrl), fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              SizedBox(height: 2),
                              Text('SKU: ${a.product.sku} • التصنيف: ${a.product.category}', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                              SizedBox(height: 2),
                              Text('بلد المنشأ: ${a.product.countryOfOrigin}', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    _buildDetailRow('المواصفات الفنية المعتمدة', a.product.specifications),
                    _buildDetailRow('تفاصيل التعبئة والتغليف', a.product.packagingDetails),
                    _buildDetailRow('الكمية الإجمالية للمشروع', '${a.product.quantity} ${a.product.unit}', isBold: true),
                  ],
                ),
                SizedBox(height: 16),

                // 6. Pricing Breakdown
                _buildSectionCard(
                  title: 'تفاصيل التكاليف والمالية اللوجستية',
                  icon: Icons.account_balance_wallet_outlined,
                  children: [
                    _buildDetailRow('سعر الوحدة المقترح الأول', '${a.pricing.originalPrice.toStringAsFixed(2)} ${a.pricing.currency}'),
                    _buildDetailRow('السعر المتفاوض عليه', '${a.pricing.negotiatedPrice.toStringAsFixed(2)} ${a.pricing.currency}'),
                    _buildDetailRow('سعر الوحدة النهائي المعتمد', '${a.pricing.finalPrice.toStringAsFixed(2)} ${a.pricing.currency}', isPrimary: true),
                    _buildDetailRow('خصومات التسوية اللوجستية', '${a.pricing.discount.toStringAsFixed(2)} ${a.pricing.currency}', isWarning: true),
                    _buildDetailRow('ضريبة القيمة المضافة (١٥٪)', '${a.pricing.tax.toStringAsFixed(2)} ${a.pricing.currency}'),
                    _buildDetailRow('رسوم الشحن والتوصيل', '${a.pricing.shippingCost.toStringAsFixed(2)} ${a.pricing.currency}'),
                    if (a.pricing.extraFees > 0) _buildDetailRow('رسوم إدارية إضافية', '${a.pricing.extraFees.toStringAsFixed(2)} ${a.pricing.currency}'),
                    const Divider(height: 16),
                    _buildDetailRow('المجموع المالي الكلي للمشروع', '${a.pricing.grandTotal.toStringAsFixed(2)} ${a.pricing.currency}', isBold: true),
                  ],
                ),
                SizedBox(height: 16),

                // 7. Payment Terms
                _buildSectionCard(
                  title: 'شروط وبنود الدفع المالي',
                  icon: Icons.payment_outlined,
                  children: [
                    _buildDetailRow('طريقة الدفع الفعلي المتبعة', a.paymentTerms.method),
                    _buildDetailRow('الدفعة المقدمة (سلفة تشغيل)', '${a.paymentTerms.advancePayment.toStringAsFixed(2)} ${a.pricing.currency}', isPrimary: true),
                    _buildDetailRow('الرصيد المتبقي المؤجل', '${a.paymentTerms.remainingBalance.toStringAsFixed(2)} ${a.pricing.currency}'),
                    _buildDetailRow('جدولة وتوزيع الأقساط المالية', a.paymentTerms.paymentSchedule),
                    _buildDetailRow('حالة الضمان المالي الموحد', a.paymentTerms.paymentStatus),
                    _buildDetailRow('شروط الفسح والإفراج المالي', a.paymentTerms.releaseConditions),
                    _buildDetailRow('مدة تسوية البنك التلقائية', a.paymentTerms.settlementTime),
                  ],
                ),
                SizedBox(height: 16),

                // 8. Delivery Terms
                _buildSectionCard(
                  title: 'شروط التوريد واللوجستيات',
                  icon: Icons.local_shipping_outlined,
                  children: [
                    _buildDetailRow('مدة تجهيز البضائع بالمصنع', a.deliveryTerms.preparationTime),
                    _buildDetailRow('تاريخ التسليم النهائي المتوقع', a.deliveryTerms.deliveryDate, isBold: true),
                    _buildDetailRow('عنوان مستودع التسليم المستهدف', a.deliveryTerms.deliveryAddress),
                    _buildDetailRow('شركة الشحن الموحدة المتفق عليها', a.deliveryTerms.shippingCompany),
                    _buildDetailRow('طريقة ونوع الشحن اللوجستي', a.deliveryTerms.shipmentMethod),
                    _buildDetailRow('رقم بوليصة التتبع والمتابعة', a.deliveryTerms.trackingNumber.isNotEmpty ? a.deliveryTerms.trackingNumber : 'لم يصدر رقم تتبع بعد'),
                    _buildDetailRow('المستودع الرئيسي للمستلم', a.deliveryTerms.warehouse),
                  ],
                ),
                SizedBox(height: 16),

                // 9. Special Conditions
                _buildSectionCard(
                  title: 'الشروط الخاصة والسياسات الجزائية',
                  icon: Icons.verified_user_outlined,
                  children: [
                    _buildDetailRow('سياسة الضمان والجودة', a.conditions.warranty),
                    _buildDetailRow('شروط مطابقة الجودة للمنسوجات', a.conditions.qualityRequirements),
                    _buildDetailRow('سياسة ومتطلبات الفحص المستودعي', a.conditions.inspectionRequirements),
                    _buildDetailRow('سياسة الإلغاء وحجز العربون', a.conditions.cancellationPolicy),
                    _buildDetailRow('الشروط والبنود الجزائية للتأخير', a.conditions.penaltyClauses),
                    _buildDetailRow('ملاحظات وإيضاحات إضافية', a.conditions.additionalNotes),
                  ],
                ),
                SizedBox(height: 30),
              ],
            ),
            bottomNavigationBar: AgreementActionButtons(a: a),
          );
        },
      ),
    );
  }

  Widget _buildNavigationRow(BuildContext context, B2BAgreement a) {
    return Row(
      children: [
        _buildNavButton(
          context, 
          label: 'مقارنة العروض', 
          icon: Icons.compare_arrows_outlined, 
          path: '/agreements/comparison/${a.id}',
        ),
        SizedBox(width: 8),
        _buildNavButton(
          context, 
          label: 'المستندات', 
          icon: Icons.description_outlined, 
          path: '/agreements/documents/${a.id}',
        ),
        SizedBox(width: 8),
        _buildNavButton(
          context, 
          label: 'الخط الزمني والسجل', 
          icon: Icons.timeline_outlined, 
          path: '/agreements/history/${a.id}?rfqId=${a.rfqNumber}',
        ),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, {required String label, required IconData icon, required String path}) {
    return Expanded(
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 4)],
        ),
        child: InkWell(
          onTap: () => context.push(path),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface),
              ),
            ],
          ),
          SizedBox(height: 10),
          Divider(height: 1, color: AppColors.surfaceContainerLow),
          SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false, bool isPrimary = false, bool isWarning = false}) {
    Color valueColor = AppColors.onSurface;
    if (isPrimary) valueColor = AppColors.primary;
    if (isWarning) valueColor = AppColors.error;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 10, color: AppColors.outline),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}