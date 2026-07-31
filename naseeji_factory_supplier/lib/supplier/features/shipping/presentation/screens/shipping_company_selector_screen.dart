import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../widgets/carrier_selector_card.dart';
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
      'cost': '250.00 جنيه',
      'time': '٢ - ٣ أيام عمل',
      'icon': Icons.local_shipping_outlined,
      'services': ['تتبع حي GPS', 'تنبيهات SMS تلقائية', 'تأمين جمركي متكامل'],
    },
    {
      'name': 'دي إتش إل DHL',
      'method': 'شحن سريع دولي (DHL Express)',
      'cost': '450.00 جنيه',
      'time': '١ - ٢ أيام عمل',
      'icon': Icons.flight_takeoff_outlined,
      'services': ['شحن جوي سريع', 'تغطية تأمينية كاملة', 'توقيع إلكتروني عند التسليم'],
    },
    {
      'name': 'سمسا SMSA Express',
      'method': 'شحن محلي سريع (SMSA Express)',
      'cost': '180.00 جنيه',
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          centerTitle: true,
          title: Text(
            'اختيار شركة الشحن لشحنة ${widget.shipmentId}',
            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text('شركات الشحن واللوجستيات المعتمدة لدى نسيجي:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            SizedBox(height: 12),

            ..._carriers.map((carrier) {
              final isSelected = _selectedCompany == carrier['name'];

              return CarrierSelectorCard(
                carrier: carrier,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedCompany = carrier['name'] as String;
                    _selectedMethod = carrier['method'] as String;
                  });
                },
                onRadioChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCompany = carrier['name'] as String;
                      _selectedMethod = carrier['method'] as String;
                    });
                  }
                },
              );
            }),

            SizedBox(height: 16),
            
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
                Text(
                  'تعيين كشركة شحن افتراضية لجميع الشحنات القادمة',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            SizedBox(height: 24),

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
              child: Text('حفظ واختيار شركة الشحن', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

