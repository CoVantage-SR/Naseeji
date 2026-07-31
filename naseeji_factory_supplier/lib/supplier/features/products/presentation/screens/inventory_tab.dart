// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class InventoryTab extends StatefulWidget {
  const InventoryTab({super.key});

  @override
  State<InventoryTab> createState() => _InventoryTabState();
}

class _InventoryTabState extends State<InventoryTab> {
  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'id': 'i1',
      'name': 'خيوط غزل القطن الفاخر',
      'sku': 'COT-YRN-001',
      'available': 5000,
      'reserved': 800,
      'moq': 500,
      'prepTime': '١٥ يوم عمل',
    },
    {
      'id': 'i2',
      'name': 'قماش قطني طبيعي ١٠٠٪',
      'sku': 'COT-FAB-002',
      'available': 340,
      'reserved': 120,
      'moq': 100,
      'prepTime': '١٠ أيام عمل',
    },
    {
      'id': 'i3',
      'name': 'نسيج صوف مخلوط مميز',
      'sku': 'WOL-MIX-003',
      'available': 950,
      'reserved': 0,
      'moq': 200,
      'prepTime': '٢٠ يوم عمل',
    },
    {
      'id': 'i4',
      'name': 'خيوط البوليستر المعالجة',
      'sku': 'PLY-YRN-004',
      'available': 0,
      'reserved': 0,
      'moq': 1000,
      'prepTime': '٧ أيام عمل',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _inventoryItems.length,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = _inventoryItems[index];
            final int available = item['available'];
            final int reserved = item['reserved'];
            final int totalStock = available + reserved;

            String statusLabel = 'متوفر';
            Color statusColor = Colors.green;
            Color statusBg = Colors.green.shade50;

            if (available == 0) {
              statusLabel = 'نفذ المخزون';
              statusColor = Colors.red;
              statusBg = Colors.red.shade50;
            } else if (available < 500) {
              statusLabel = 'مخزون منخفض';
              statusColor = Colors.orange.shade800;
              statusBg = Colors.orange.shade50;
            }

            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product info & Badge
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'رمز المنتج: ${item['sku']}',
                              style: TextStyle(fontSize: 10, color: AppColors.outline),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  const Divider(),
                  SizedBox(height: 10),
                  // Inventory Breakdown
                  _buildInventoryRow('إجمالي المخزون المادي', '$totalStock وحدة', isBold: true),
                  _buildInventoryRow('الكمية المتوفرة للبيع', '$available وحدة', valueColor: available < 500 ? Colors.orange.shade800 : null),
                  _buildInventoryRow('الكمية المحجوزة للطلبات المعلقة', '$reserved وحدة'),
                  _buildInventoryRow('الحد الأدنى للطلب (MOQ)', '${item['moq']} وحدة'),
                  _buildInventoryRow('وقت التجهيز والشحن', item['prepTime']),
                  SizedBox(height: 14),
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton.icon(
                      onPressed: () => _showUpdateStockDialog(context, item),
                      icon: const Icon(Icons.edit_calendar_outlined, size: 16),
                      label: Text('تعديل كميات المخزون والمواصفات', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInventoryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isBold ? Theme.of(context).colorScheme.onSurface : AppColors.outline,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context, Map<String, dynamic> item) {
    final availableCtrl = TextEditingController(text: item['available'].toString());
    final reservedCtrl = TextEditingController(text: item['reserved'].toString());

    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تحديث مخزون ${item['name']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), textAlign: TextAlign.right),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: availableCtrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'الكمية المتوفرة للبيع (وحدة)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: reservedCtrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'الكمية المحجوزة للطلبات (وحدة)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                final availVal = int.tryParse(availableCtrl.text.trim());
                final resVal = int.tryParse(reservedCtrl.text.trim());

                if (availVal != null && resVal != null) {
                  setState(() {
                    final idx = _inventoryItems.indexWhere((i) => i['id'] == item['id']);
                    if (idx != -1) {
                      _inventoryItems[idx]['available'] = availVal;
                      _inventoryItems[idx]['reserved'] = resVal;
                    }
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم تحديث بيانات المخزون بنجاح.')),
                  );
                }
              },
              child: Text('حفظ التعديلات'),
            ),
          ],
        ),
      ),
    );
  }
}



