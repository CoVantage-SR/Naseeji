import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/shipping_controller.dart';

class ShippingCompanySelectorScreen extends ConsumerStatefulWidget {
  final String shipmentId;

  const ShippingCompanySelectorScreen({super.key, required this.shipmentId});

  @override
  ConsumerState<ShippingCompanySelectorScreen> createState() => _ShippingCompanySelectorScreenState();
}

class _ShippingCompanySelectorScreenState extends ConsumerState<ShippingCompanySelectorScreen> {
  String _selectedCompany = 'أرامكس Aramex';
  String _selectedMethod = 'شحن بري سريع (Aramex Ground)';
  bool _saveAsDefault = false;

  final List<Map<String, dynamic>> _carriers = [
    {
      'name': 'أرامكس Aramex',
      'method': 'شحن بري سريع (Aramex Ground)',
      'cost': '250.00 ر.س',
      'time': '٢ - ٣ أيام عمل',
      'icon': Icons.local_shipping_outlined,
      'services': ['تتبع حي GPS', 'تنبيهات SMS تلقائية', 'تأمين جمركي متكامل'],
    },
    {
      'name': 'دي إتش إل DHL',
      'method': 'شحن سريع دولي (DHL Express)',
      'cost': '450.00 ر.س',
      'time': '١ - ٢ أيام عمل',
      'icon': Icons.flight_takeoff_outlined,
      'services': ['شحن جوي سريع', 'تغطية تأمينية كاملة', 'توقيع إلكتروني عند التسليم'],
    },
    {
      'name': 'سمسا SMSA Express',
      'method': 'شحن محلي سريع (SMSA Express)',
      'cost': '180.00 ر.س',
      'time': '٣ - ٤ أيام عمل',
      'icon': Icons.speed_outlined,
      'services': ['تتبع محلي عبر النظام', 'استلام من الباب للباب'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FF),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'اختيار شركة الشحن لشحنة $widget.shipmentId',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Text('شركات الشحن واللوجستيات المعتمدة لدى نسيجي:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 12),

            ..._carriers.map((carrier) {
              final isSelected = _selectedCompany == carrier['name'];

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isSelected ? const Color(0xFF0040E0) : AppColors.surfaceContainerLow, width: isSelected ? 2 : 1),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCompany = carrier['name'];
                      _selectedMethod = carrier['method'];
                    });
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(carrier['icon'], color: isSelected ? const Color(0xFF0040E0) : AppColors.outline, size: 22),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(carrier['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface)),
                                  const SizedBox(height: 2),
                                  Text(carrier['method'], style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: carrier['name'],
                              groupValue: _selectedCompany,
                              activeColor: const Color(0xFF0040E0),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedCompany = val;
                                    _selectedMethod = carrier['method'];
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          children: [
                            const Text('التكلفة المقدرة: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                            Text(carrier['cost'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                            const Spacer(),
                            const Text('مدة التوصيل: ', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                            Text(carrier['time'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: (carrier['services'] as List<String>).map((srv) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(6)),
                            child: Text(srv, style: const TextStyle(fontSize: 8, color: AppColors.outline, fontWeight: FontWeight.bold)),
                          )).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 16),
            
            // Checkbox options
            Row(
              children: [
                Checkbox(
                  value: _saveAsDefault,
                  activeColor: const Color(0xFF0040E0),
                  onChanged: (val) {
                    setState(() {
                      _saveAsDefault = val ?? false;
                    });
                  },
                ),
                const Text(
                  'تعيين كشركة شحن افتراضية لجميع الشحنات القادمة',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                ref.read(shippingControllerProvider.notifier).selectCarrierDetails(
                  widget.shipmentId,
                  carrier: _selectedCompany,
                  method: _selectedMethod,
                );
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تحديد السائق وتحديث شركة الشحن إلى: $_selectedCompany')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0040E0),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('حفظ واختيار شركة الشحن', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
