import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';

class FactoryInfoHeaderWidget extends StatelessWidget {
  final bool compact;
  const FactoryInfoHeaderWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'بيانات المصنع',
          style: compact
              ? context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )
              : context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),
        if (!compact) ...[
          AppSpacing.hXS,
          Text(
            'أدخل تفاصيل المصنع لإكمال إنشاء الملف التجاري.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ],
    );
  }
}

class FactoryNameWidget extends StatelessWidget {
  final TextEditingController controller;

  const FactoryNameWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'يرجى إدخال اسم المصنع';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'اسم المصنع بالكامل',
        prefixIcon: Icon(Icons.factory_outlined),
        hintText: 'مثال: مصنع النيل للغزل والنسيج',
      ),
    );
  }
}

class OwnerNameWidget extends StatelessWidget {
  final TextEditingController controller;

  const OwnerNameWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'يرجى إدخال اسم المفوض أو المالك';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'اسم المالك أو المفوض المسؤول',
        prefixIcon: Icon(Icons.person_outline_rounded),
        hintText: 'مثال: محمد أحمد علي',
      ),
    );
  }
}

class GovernorateWidget extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const GovernorateWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final List<String> _governorates = const [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'القليوبية',
    'الغربية',
    'الدقهلية',
    'الشرقية',
    'المنوفية',
    'البحيرة',
    'الفيوم',
    'بني سويف',
    'المنيا',
    'أسيوط',
    'سوهاج',
    'قنا',
    'الأقصر',
    'أسوان',
    'بورسعيد',
    'الإسماعيلية',
    'السويس',
    'دمياط',
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'يرجى اختيار المحافظة';
        }
        return null;
      },
      alignment: Alignment.centerRight,
      decoration: const InputDecoration(
        labelText: 'المحافظة',
        prefixIcon: Icon(Icons.location_on_outlined),
      ),
      items: _governorates.map((gov) {
        return DropdownMenuItem<String>(
          value: gov,
          alignment: Alignment.centerRight,
          child: Text(gov),
        );
      }).toList(),
    );
  }
}

class CityWidget extends StatelessWidget {
  final TextEditingController controller;

  const CityWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'يرجى إدخال المدينة أو المنطقة';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'المدينة / المنطقة السكنية',
        prefixIcon: Icon(Icons.location_city_outlined),
        hintText: 'مثال: المحلة الكبرى، شبرا الخيمة',
      ),
    );
  }
}

class EmployeesWidget extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const EmployeesWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final List<String> _ranges = const [
    '1-10',
    '11-50',
    '51-200',
    '200+',
  ];

  @override
  Widget build(BuildContext context) {
    final resolvedValue = _ranges.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      initialValue: resolvedValue,
      onChanged: onChanged,
      alignment: Alignment.centerRight,
      decoration: const InputDecoration(
        labelText: 'عدد العمال والموظفين (اختياري)',
        prefixIcon: Icon(Icons.people_outline_rounded),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          alignment: Alignment.centerRight,
          child: Text('غير محدد'),
        ),
        ..._ranges.map((range) {
          return DropdownMenuItem<String>(
            value: range,
            alignment: Alignment.centerRight,
            child: Text('$range موظف'),
          );
        }),
      ],
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  final TextEditingController controller;

  const DescriptionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'وصف عن المصنع وقدرات الإنتاج',
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: 56.0),
          child: Icon(Icons.description_outlined),
        ),
        hintText: 'اكتب نبذة مختصرة عن نوعية المنتجات التي تصنعها والماكينات المتوفرة لديك...',
      ),
    );
  }
}


