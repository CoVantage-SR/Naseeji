import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class ProductionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProductionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final pct = (data['completionPct'] as num? ?? 0).toDouble();
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF8B5CF6), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF8B5CF6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Spacer(),
                Icon(Icons.factory_outlined, color: Theme.of(context).colorScheme.surface, size: 18),
                SizedBox(width: 6),
                Text('تحديث الإنتاج', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${pct.toInt()}%',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6))),
                    Text('نسبة الإنجاز', style: TextStyle(fontSize: 11, color: AppColors.outline)),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: pct / 100,
                  backgroundColor: Colors.purple.shade50,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF8B5CF6)),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: 10),
                if (data['notes'] != null)
                  Text(data['notes'] as String,
                      style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.right),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF8B5CF6)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('طلب تعديل', style: TextStyle(fontSize: 12, color: Color(0xFF8B5CF6))),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8B5CF6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('مراجعة', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



