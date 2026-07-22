import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/deal_model.dart';
import '../controllers/deals_controller.dart';

class ProductionWidget extends ConsumerStatefulWidget {
  final DealModel deal;

  const ProductionWidget({super.key, required this.deal});

  @override
  ConsumerState<ProductionWidget> createState() => _ProductionWidgetState();
}

class _ProductionWidgetState extends ConsumerState<ProductionWidget> {
  late double _progress;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _progress = widget.deal.production?.progressPercent ?? 0.25;
    _notesCtrl = TextEditingController(text: widget.deal.production?.notes ?? '');
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final prod = widget.deal.production;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.precision_manufacturing_outlined, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 6),
                        Text(
                          'متابعة خط الإنتاج والتصنيع',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
                        ),
                      ],
                    ),
                    Text(
                      '${(_progress * 100).toInt()}% مكتمل',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Progress Bar Slider
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.surfaceContainerLow,
                ),
                const SizedBox(height: 12),

                // Slider Controls for updating progress
                Text('تحديث نسبة الإنجاز والتصنيع:', style: TextStyle(fontSize: 10, color: colorScheme.outline)),
                Slider(
                  value: _progress,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                  label: '${(_progress * 100).toInt()}%',
                  onChanged: (val) {
                    setState(() => _progress = val);
                  },
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 11),
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات وتحديثات خط الإنتاج اليومية',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
                const SizedBox(height: 10),

                // Upload Media Placeholder
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                        label: const Text('رفع صورة إنتاج', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.videocam_outlined, size: 16),
                        label: const Text('رفع فيديو للخط', style: TextStyle(fontSize: 10)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _updateProgress,
                    icon: const Icon(Icons.save_rounded, size: 16),
                    label: const Text('حفظ وتحديث نسبة الإنتاج للمصنع'),
                    style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Photos gallery
          if (prod != null && prod.photoUrls.isNotEmpty) ...[
            Text('صور وفيديوهات الإنتاج المرفوعة:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
            const SizedBox(height: 6),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: prod.photoUrls.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(prod.photoUrls[index], width: 70, height: 70, fit: BoxFit.cover),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _updateProgress() async {
    final success = await ref.read(dealsControllerProvider.notifier).updateProduction(
          dealId: widget.deal.id,
          progressPercent: _progress,
          photoUrls: widget.deal.production?.photoUrls ?? [],
          videoUrls: widget.deal.production?.videoUrls ?? [],
          notes: _notesCtrl.text,
        );

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تحديث نسبة الإنجاز إلى ${(_progress * 100).toInt()}% بنجاح 🛠️'), backgroundColor: Colors.green),
      );
    }
  }
}
