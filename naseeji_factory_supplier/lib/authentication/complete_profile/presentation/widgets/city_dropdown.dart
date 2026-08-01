import 'package:flutter/material.dart';

class CityDropdown extends StatelessWidget {
  final String? selectedGovernorate;
  final String? selectedCity;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  const CityDropdown({
    super.key,
    this.selectedGovernorate,
    this.selectedCity,
    this.errorText,
    required this.onChanged,
  });

  static const Map<String, List<String>> cityMap = {
    'القاهرة': [
      'مدينة نصر',
      'التجمع الخامس',
      'شبرا',
      'مصر الجديدة',
      'حلوان',
      '15 مايو',
      'المقطم',
    ],
    'الجيزة': [
      '6 أكتوبر',
      'الشيخ زايد',
      'الهرم',
      'فيصل',
      'العجوزة',
      'الدقي',
      'المنشية',
    ],
    'الإسكندرية': [
      'برج العرب',
      'سموحة',
      'المنتزه',
      'العجمي',
      'محرم بك',
      'سيدي جابر',
    ],
    'الغربية': [
      'المحلة الكبرى',
      'طنطا',
      'زفتى',
      'كفر الزيات',
      'سمنود',
      'قطور',
    ],
    'الدقهلية': [
      'المنصورة',
      'ميت غمر',
      'طلخا',
      'دكرنس',
      'شربين',
    ],
    'الشرقية': [
      'العاشر من رمضان',
      'الزقازيق',
      'بلبيس',
      'فاقوس',
      'أبو حماد',
    ],
    'المنوفية': [
      'شبين الكوم',
      'مدينة السادات',
      'قويسنا',
      'أشمون',
    ],
    'القليوبية': [
      'العبور',
      'شبرا الخيمة',
      'بنها',
      'قليوب',
    ],
    'البحيرة': [
      'دمنهور',
      'كفر الدوار',
      'إيتاي البارود',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final availableCities = selectedGovernorate != null
        ? (cityMap[selectedGovernorate] ?? ['المركز الرئيسي'])
        : <String>[];

    final isDisabled = selectedGovernorate == null || availableCities.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المدينة / المنطقة *',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          key: ValueKey('${selectedGovernorate}_$selectedCity'),
          initialValue: availableCities.contains(selectedCity) ? selectedCity : null,
          onChanged: isDisabled ? null : onChanged,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: selectedGovernorate == null
                ? 'اختر المحافظة أولاً'
                : 'اختر المدينة / المنطقة',
            prefixIcon: Icon(
              Icons.location_city_outlined,
              color: colorScheme.outline,
            ),
            errorText: errorText,
          ),
          items: availableCities.map((city) {
            return DropdownMenuItem<String>(
              value: city,
              child: Text(
                city,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
