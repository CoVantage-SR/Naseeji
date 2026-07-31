import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/deals/domain/entities/deal_model.dart';

class DealInfoWidget extends StatelessWidget {
  final DealModel deal;

  const DealInfoWidget({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Factory & Supplier Info
          _buildCard(
            context,
            title: 'أطراف الصفقة',
            icon: Icons.business_rounded,
            child: Column(
              children: [
                _buildPartyRow(
                  context,
                  role: 'المصنع (المشتري):',
                  name: deal.factoryInfo.name,
                  city: deal.factoryInfo.city,
                  bgColor: Color(deal.factoryInfo.logoBgColorValue),
                  logoText: deal.factoryInfo.logoText,
                ),
                const SizedBox(height: 8),
                Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                const SizedBox(height: 8),
                _buildPartyRow(
                  context,
                  role: 'المورد (المورّد):',
                  name: deal.supplierInfo.name,
                  city: deal.supplierInfo.city,
                  bgColor: Color(deal.supplierInfo.logoBgColorValue),
                  logoText: deal.supplierInfo.logoText,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Section 2: Product & Specs Details
          _buildCard(
            context,
            title: 'تفاصيل المنتج والخامة المطلوبة',
            icon: Icons.inventory_2_outlined,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    deal.product.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 60,
                      height: 60,
                      color: colorScheme.primaryContainer,
                      child: Icon(Icons.texture_rounded, color: colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deal.product.name,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                      ),
                      const SizedBox(height: 2),
                      Text('كود SKU: ${deal.product.sku}', style: TextStyle(fontSize: 10, color: colorScheme.outline)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _buildChip(context, 'الكمية: ${deal.product.quantity} ${deal.product.unit}'),
                          const SizedBox(width: 6),
                          _buildChip(context, 'السعر التقديري: ${deal.product.unitPrice} ${deal.product.currency}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Section 3: Financial Summary
          _buildCard(
            context,
            title: 'الملخص المالي المبدئي',
            icon: Icons.payments_outlined,
            child: Column(
              children: [
                _buildLabelValue(context, 'إجمالي الكمية المطلوبة:', '${deal.product.quantity} ${deal.product.unit}'),
                _buildLabelValue(context, 'سعر الوحدة المقدر:', '${deal.product.unitPrice} ${deal.product.currency}'),
                Divider(height: 12, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                _buildLabelValue(
                  context,
                  'القيمة الإجمالية المتوقعة:',
                  '${deal.product.totalPrice} ${deal.product.currency}',
                  isBold: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required IconData icon, required Widget child}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildPartyRow(
    BuildContext context, {
    required String role,
    required String name,
    required String city,
    required Color bgColor,
    required String logoText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: bgColor,
          child: Text(
            logoText.substring(0, 1),
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(role, style: TextStyle(fontSize: 9.5, color: colorScheme.outline)),
              Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            ],
          ),
        ),
        Text(city, style: TextStyle(fontSize: 9.5, color: colorScheme.outline)),
      ],
    );
  }

  Widget _buildChip(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: colorScheme.primary),
      ),
    );
  }

  Widget _buildLabelValue(BuildContext context, String label, String value, {bool isBold = false}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant)),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 12 : 10.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isBold ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

