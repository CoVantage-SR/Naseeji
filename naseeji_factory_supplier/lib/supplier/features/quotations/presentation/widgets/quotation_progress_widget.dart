// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/quotation_model.dart';

class QuotationProgressWidget extends StatelessWidget {
  final QuotationModel quotation;

  const QuotationProgressWidget({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    // Definitive stages in a quotation lifecycle
    final List<String> stages = [
      'استلام RFQ',
      'مسودة العرض',
      'مرسل ومراجعة',
      'تفاوض ونقاش',
      'قبول العرض',
    ];

    int activeIndex = 0;
    Color activeColor = AppColors.primary;

    switch (quotation.status) {
      case QuotationStatus.draft:
        activeIndex = 1;
        break;
      case QuotationStatus.sent:
        activeIndex = 2;
        break;
      case QuotationStatus.underNegotiation:
        activeIndex = 3;
        activeColor = Colors.orange;
        break;
      case QuotationStatus.accepted:
        activeIndex = 4;
        activeColor = Colors.green;
        break;
      case QuotationStatus.rejected:
        activeIndex = 4;
        activeColor = Colors.red;
        stages[4] = 'مرفوض';
        break;
      case QuotationStatus.expired:
        activeIndex = 3;
        activeColor = Colors.grey.shade700;
        stages[3] = 'منتهي';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مراحل دورة حياة التسعير',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.onSurface),
              ),
              Text(
                stages[activeIndex],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: activeColor),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          Row(
            children: List.generate(stages.length * 2 - 1, (index) {
              if (index.isOdd) {
                // Divider line
                final lineIndex = index ~/ 2;
                final isCompleted = lineIndex < activeIndex;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted ? activeColor : const Color(0xFFE2E1EF),
                  ),
                );
              } else {
                // Step Dot
                final stepIndex = index ~/ 2;
                final isCurrent = stepIndex == activeIndex;
                final isCompleted = stepIndex < activeIndex;
                
                final Color stepColor = isCurrent || isCompleted ? activeColor : const Color(0xFFC4C5D9);

                return Tooltip(
                  message: stages[stepIndex],
                  child: Column(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isCurrent ? Colors.white : stepColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: stepColor,
                            width: isCurrent ? 5 : 2,
                          ),
                        ),
                        child: isCompleted
                            ? Icon(Icons.check, color: AppColors.surface, size: 10)
                            : null,
                      ),
                      SizedBox(height: 6),
                      Text(
                        stages[stepIndex],
                        style: TextStyle(
                          fontSize: 7, 
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                          color: isCurrent ? activeColor : AppColors.outline,
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}

