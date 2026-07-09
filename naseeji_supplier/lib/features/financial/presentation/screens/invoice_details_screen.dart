import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/financial_models.dart';
import '../widgets/payment_status_badge.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  final String invoiceNumber;
  final SupplierInvoice? invoice;

  const InvoiceDetailsScreen({
    super.key,
    required this.invoiceNumber,
    this.invoice,
  });

  @override
  Widget build(BuildContext context) {
    final inv = invoice ??
        SupplierInvoice(
          invoiceNumber: invoiceNumber,
          factoryName: 'مصنع نسيج الرياض',
          orderNumber: 'ORD-5541',
          agreementNumber: 'AGR-8802',
          invoiceDate: DateTime.now().subtract(const Duration(days: 1)),
          dueDate: DateTime.now().add(const Duration(days: 14)),
          subtotal: 13000.0,
          tax: 1950.0,
          shipping: 350.0,
          discount: 800.0,
          grandTotal: 14500.0,
          status: InvoiceStatus.paid,
          items: [
            const InvoiceItem(name: 'قماش كتان بيج ممتاز', quantity: 300, unitPrice: 30.0, unit: 'متر'),
            const InvoiceItem(name: 'قماش قطن مصري أبيض', quantity: 200, unitPrice: 20.0, unit: 'متر'),
          ],
          paymentHistory: [],
          attachments: ['INV-2026-0045-signed.pdf'],
        );

    final issueDateStr = '${inv.invoiceDate.year}-${inv.invoiceDate.month.toString().padLeft(2, '0')}-${inv.invoiceDate.day.toString().padLeft(2, '0')}';
    final dueDateStr = '${inv.dueDate.year}-${inv.dueDate.month.toString().padLeft(2, '0')}-${inv.dueDate.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل فاتورة التوريد',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PaymentStatusBadge(status: inv.status),
                        Text(
                          inv.invoiceNumber,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.outline),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '${inv.grandTotal.toStringAsFixed(2)} ر.س',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'المصنع المستفيد: ${inv.factoryName}',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Date card
              _buildTitle('التواريخ والمستندات المرتبطة'),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    _buildRow('تاريخ تحرير الفاتورة', issueDateStr),
                    const Divider(height: 20),
                    _buildRow('تاريخ استحقاق السداد', dueDateStr),
                    const Divider(height: 20),
                    _buildRow('رقم طلب الشراء (Order)', inv.orderNumber),
                    const Divider(height: 20),
                    _buildRow('رقم اتفاقية التوريد (Agreement)', inv.agreementNumber),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Itemized products list
              _buildTitle('بنود الفاتورة والمواد الموردة'),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: List.generate(inv.items.length, (index) {
                    final item = inv.items[index];
                    final total = item.quantity * item.unitPrice;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${total.toStringAsFixed(2)} ر.س',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            Text(
                              item.name,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'سعر الوحدة: ${item.unitPrice.toStringAsFixed(2)} ر.س',
                              style: TextStyle(fontSize: 11, color: AppColors.outline),
                            ),
                            Text(
                              'الكمية: ${item.quantity} ${item.unit}',
                              style: TextStyle(fontSize: 11, color: AppColors.outline),
                            ),
                          ],
                        ),
                        if (index < inv.items.length - 1)
                          const Divider(height: 20, color: AppColors.outlineVariant),
                      ],
                    );
                  }),
                ),
              ),
              SizedBox(height: 20),

              // Financial breakdown
              _buildTitle('الملخص المالي والتحليل الضريبي'),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    _buildRow('المجموع الفرعي', '${inv.subtotal.toStringAsFixed(2)} ر.س'),
                    const Divider(height: 20),
                    _buildRow('قيمة الخصم التجاري', '-${inv.discount.toStringAsFixed(2)} ر.س'),
                    const Divider(height: 20),
                    _buildRow('تكلفة الشحن والتعبئة', '${inv.shipping.toStringAsFixed(2)} ر.س'),
                    const Divider(height: 20),
                    _buildRow('ضريبة القيمة المضافة (15%)', '${inv.tax.toStringAsFixed(2)} ر.س'),
                    const Divider(height: 20),
                    _buildRow('المجموع الكلي النهائي', '${inv.grandTotal.toStringAsFixed(2)} ر.س', isHighlight: true),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Attachments
              if (inv.attachments.isNotEmpty) ...[
                _buildTitle('المرفقات والشهادات المرفقة'),
                SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: inv.attachments.map((filename) {
                      return ListTile(
                        leading: const Icon(Icons.picture_as_pdf, color: Color(0xFFBA1A1A)),
                        title: Text(filename, style: TextStyle(fontSize: 12), textAlign: TextAlign.right),
                        trailing: const Icon(Icons.download, size: 18),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تحميل المرفق $filename...')),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Actions
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('جاري إنشاء وتحميل الفاتورة PDF...')),
                  );
                },
                icon: const Icon(Icons.download),
                label: Text('تحميل الفاتورة (PDF)'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.right,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
    );
  }

  Widget _buildRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlight ? 15 : 13,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.primary : AppColors.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isHighlight ? AppColors.onSurface : AppColors.outline,
            fontWeight: isHighlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}