import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class OfferPreviewDocument extends StatelessWidget {
  final String rfqId;

  const OfferPreviewDocument({super.key, required this.rfqId});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Header line indicator
            Container(
              width: double.infinity,
              height: 4,
              decoration: BoxDecoration(
                color: Color(0xFF0040E0),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Company Brand Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0040E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.grid_view_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Naseeji',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0040E0),
                      ),
                    ),
                    Text(
                      'شركة نسيجك للمنسوجات المتطورة',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Sub company details
            const Text(
              'الرياض، المنطقة الصناعية الثانية\nالرقم الضريبي: ٣٠٠٤٥٥٦٧٨٩٠٠٠٠٣\nهاتف: ٩٦٦١١٥٦٧٨٢٣٤+',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.outline,
                height: 1.5,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(height: 12),

            // Preliminary badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0040E0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'عرض سعر مبدئي',
                  style: TextStyle(
                    color: Color(0xFF0040E0),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // To Client metadata
            const Text(
              'إلى: مصنع الغد للحلول الذكية',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 12),

            // Offer data metadata grid
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMetaRow('رقم العرض', 'QT-2024-089'),
                  const SizedBox(height: 8),
                  _buildMetaRow('تاريخ الإصدار', '١٢ أكتوبر ٢٠٢٤'),
                  const SizedBox(height: 8),
                  _buildMetaRow('صالح حتى', '٢٦ أكتوبر ٢٠٢٤'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Product Details Table Title
            const Text(
              'المنتجات والأسعار',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),

            // Table layout
            _buildTableHeader(),
            _buildTableRow('بوليستر صناعي فاخر - أبيض\nكود: PE-992 | لفة ٥٠ متر', '٦٠', '٤٥٠.٠٠ ر.س'),
            _buildTableRow('قطن عضوي ١٠٠٪ نسيج ناعم\nكود: CT-442 | لفة ٥٠ متر', '١٠٠', '٦٨٠.٠٠ ر.س'),
            _buildTableRow('خيوط حريرية معالجة\nكود: SI-102 | عبوة صناعية', '٥', '١,٢٠٠.٠٠ ر.س'),

            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFE2E1EF)),
            const SizedBox(height: 16),

            // Terms and Conditions Section
            const Text(
              'الشروط والأحكام',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0040E0)),
            ),
            const SizedBox(height: 8),
            const Text(
              '• الأسعار المعروضة تشمل رسوم التغليف الصناعي.\n• يتم التسليم خلال ٥-٧ أيام عمل من تاريخ التعميد.\n• طريقة الدفع: ٥٠٪ مقدماً و ٥٠٪ عند الاستلام.\n• هذا العرض خاضع لتوافر المخزون في تاريخ الطلب.',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.onSurfaceVariant,
                height: 1.6,
              ),
              textAlign: TextAlign.end,
            ),
            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFE2E1EF)),
            const SizedBox(height: 16),

            // Subtotal and Totals Section
            _buildSummaryRow('المجموع الفرعي', '٢١,٨٠٠.٠٠ ر.س'),
            const SizedBox(height: 8),
            _buildSummaryRow('ضريبة القيمة المضافة (١٥٪)', '٣,٢٧٠.٠٠ ر.س'),
            const SizedBox(height: 8),
            _buildSummaryRow('رسوم الشحن', '٢٥٠.٠٠ ر.س'),
            const SizedBox(height: 14),

            // Grand total badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF0040E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.receipt_long_outlined, color: Colors.white, size: 20),
                  Row(
                    children: [
                      Text(
                        '٢٥,٣٢٠.٠٠ ر.س',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'الإجمالي الكلي',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Signoff Footer
            const Center(
              child: Column(
                children: [
                  Text(
                    'صدر بواسطة: م. أحمد منصور - مدير المبيعات',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'sales@naseeji.sa  •  www.naseeji.sa',
                    style: TextStyle(fontSize: 10, color: AppColors.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        const Spacer(),
        Text(
          ':$label',
          style: const TextStyle(fontSize: 11, color: AppColors.outline),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFF1F1F5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('الإجمالي', textAlign: TextAlign.left, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          Expanded(child: Text('سعر الوحدة', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          Expanded(child: Text('الكمية', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text('المنتج', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildTableRow(String desc, String qty, String unitPrice) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF1F1F5), width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(flex: 2, child: Text('—', textAlign: TextAlign.left, style: TextStyle(fontSize: 10))),
          Expanded(child: Text(unitPrice, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant))),
          Expanded(child: Text(qty, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant))),
          Expanded(
            flex: 3,
            child: Text(
              desc,
              style: const TextStyle(fontSize: 10, color: AppColors.onSurface, fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        const Spacer(),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.outline),
        ),
      ],
    );
  }
}

class OfferPreviewBottomBar extends StatelessWidget {
  final VoidCallback onSend;

  const OfferPreviewBottomBar({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E1EF), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.download_rounded, color: AppColors.onSurfaceVariant),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0040E0),
                  side: const BorderSide(color: Color(0xFF0040E0), width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'تعديل',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onSend,
                icon: const Icon(Icons.send, size: 16, color: Colors.white),
                label: const Text(
                  'إرسال',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0040E0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(0, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
