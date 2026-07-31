import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/customer_model.dart';

class CustomerRatingWidget extends StatefulWidget {
  final CustomerRating rating;
  final bool readOnly;
  final void Function(CustomerRating)? onChanged;

  const CustomerRatingWidget({
    super.key,
    required this.rating,
    this.readOnly = true,
    this.onChanged,
  });

  @override
  State<CustomerRatingWidget> createState() => _CustomerRatingWidgetState();
}

class _CustomerRatingWidgetState extends State<CustomerRatingWidget> {
  late CustomerRating _current;

  @override
  void initState() {
    super.initState();
    _current = widget.rating;
  }

  final List<(String, String)> _criteria = const [
    ('paymentReliability', 'الموثوقية في الدفع'),
    ('communication', 'التواصل'),
    ('negotiation', 'التفاوض'),
    ('responseSpeed', 'سرعة الاستجابة'),
    ('orderFrequency', 'تكرار الطلبات'),
    ('deliveryCooperation', 'التعاون في التسليم'),
    ('overallRelationship', 'العلاقة العامة'),
  ];

  double _getValue(String key) {
    switch (key) {
      case 'paymentReliability': return _current.paymentReliability;
      case 'communication': return _current.communication;
      case 'negotiation': return _current.negotiation;
      case 'responseSpeed': return _current.responseSpeed;
      case 'orderFrequency': return _current.orderFrequency;
      case 'deliveryCooperation': return _current.deliveryCooperation;
      default: return _current.overallRelationship;
    }
  }

  CustomerRating _setValue(String key, double value) {
    switch (key) {
      case 'paymentReliability': return _current.copyWith(paymentReliability: value);
      case 'communication': return _current.copyWith(communication: value);
      case 'negotiation': return _current.copyWith(negotiation: value);
      case 'responseSpeed': return _current.copyWith(responseSpeed: value);
      case 'orderFrequency': return _current.copyWith(orderFrequency: value);
      case 'deliveryCooperation': return _current.copyWith(deliveryCooperation: value);
      default: return _current.copyWith(overallRelationship: value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Average score header
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 28),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _current.average.toStringAsFixed(1),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  Text('متوسط التقييم الخاص', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                ],
              ),
              const Spacer(),
              if (!widget.readOnly)
                TextButton(
                  onPressed: () => widget.onChanged?.call(_current),
                  child: Text('حفظ', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
        SizedBox(height: 12),
        ..._criteria.map((c) => _buildCriterionRow(c.$1, c.$2)),
      ],
    );
  }

  Widget _buildCriterionRow(String key, String label) {
    final value = _getValue(key);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
              Row(
                children: List.generate(5, (i) {
                  final filled = i < value.round();
                  return GestureDetector(
                    onTap: widget.readOnly ? null : () {
                      setState(() => _current = _setValue(key, (i + 1).toDouble()));
                    },
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 16,
                      color: filled ? const Color(0xFFFFB800) : AppColors.outline,
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: value / 5.0,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
            valueColor: AlwaysStoppedAnimation<Color>(_getBarColor(value)),
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Color _getBarColor(double value) {
    if (value >= 4) return Colors.green;
    if (value >= 3) return const Color(0xFFFFB800);
    return AppColors.error;
  }
}


