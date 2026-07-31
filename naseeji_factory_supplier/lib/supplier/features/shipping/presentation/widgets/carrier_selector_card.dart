// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';

class CarrierSelectorCard extends StatelessWidget {
  final Map<String, dynamic> carrier;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<String?>? onRadioChanged;

  const CarrierSelectorCard({
    super.key,
    required this.carrier,
    required this.isSelected,
    required this.onTap,
    this.onRadioChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF0040E0)
              : Theme.of(context).colorScheme.surfaceContainerLow,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    carrier['icon'] as IconData,
                    color: isSelected
                        ? const Color(0xFF0040E0)
                        : AppColors.outline,
                    size: 22,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          carrier['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          carrier['method'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Radio<String>(
                    value: carrier['name'] as String,
                    groupValue: isSelected ? (carrier['name'] as String) : '',
                    activeColor: const Color(0xFF0040E0),
                    onChanged: onRadioChanged,
                  ),
                ],
              ),
              const Divider(height: 16),
              Row(
                children: [
                  Text(
                    'التكلفة المقدرة: ',
                    style: TextStyle(fontSize: 11, color: AppColors.outline),
                  ),
                  Text(
                    carrier['cost'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'مدة التوصيل: ',
                    style: TextStyle(fontSize: 11, color: AppColors.outline),
                  ),
                  Text(
                    carrier['time'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: (carrier['services'] as List<String>)
                    .map(
                      (srv) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          srv,
                          style: TextStyle(
                            fontSize: 8,
                            color: AppColors.outline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

