import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_form_data.dart';
import '../controllers/add_product_controller.dart';

class Step2TechSpecsWidget extends ConsumerStatefulWidget {
  final ProductFormData formData;

  const Step2TechSpecsWidget({super.key, required this.formData});

  @override
  ConsumerState<Step2TechSpecsWidget> createState() => _Step2TechSpecsWidgetState();
}

class _Step2TechSpecsWidgetState extends ConsumerState<Step2TechSpecsWidget> {
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _valController = TextEditingController();

  @override
  void dispose() {
    _keyController.dispose();
    _valController.dispose();
    super.dispose();
  }

  void _showAddSpecDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة مواصفة فنية جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(
                labelText: 'اسم المواصفة',
                hintText: 'مثال: نسبة الانكماش أو درجة ثبات اللون',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valController,
              decoration: const InputDecoration(
                labelText: 'القيمة',
                hintText: 'مثال: أقل من 2% أو 4 درجات',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(addProductControllerProvider.notifier).addTechSpec(
                    _keyController.text,
                    _valController.text,
                  );
              _keyController.clear();
              _valController.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 36),
            ),
            child: const Text('إضافة المواصفة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final specs = widget.formData.technicalSpecs;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المواصفات الفنية للخامة والنسيج',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'أضف تفاصيل المواصفات مثل (الخامة، الوزن، السُمك، العرض). يمكنك إضافة عدد غير محدود.',
                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddSpecDialog(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('إضافة مواصفة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Presets Quick Add Row
          Text('مواصفات شائعة مقترحة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildPresetChip('الخامة', 'قطن 100%'),
              _buildPresetChip('الوزن', '220 جرام/متر'),
              _buildPresetChip('العرض', '180 سم'),
              _buildPresetChip('السُمك', '0.5 مم'),
              _buildPresetChip('الوحدة', 'كجم'),
            ],
          ),
          const SizedBox(height: 16),

          // Specs List Table Card
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: specs.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text('لم تقم بإضافة مواصفات فنية بعد. اضغط على زر "إضافة مواصفة" بالأعلى.'),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: specs.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                    itemBuilder: (context, index) {
                      final key = specs.keys.elementAt(index);
                      final val = specs[key]!;

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 14,
                          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary),
                          ),
                        ),
                        title: Text(key, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        subtitle: Text(val, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                          onPressed: () {
                            ref.read(addProductControllerProvider.notifier).removeTechSpec(key);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetChip(String key, String defaultVal) {
    final colorScheme = Theme.of(context).colorScheme;
    final exists = widget.formData.technicalSpecs.containsKey(key);

    return ActionChip(
      avatar: Icon(
        exists ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
        size: 14,
        color: exists ? Colors.green.shade800 : colorScheme.primary,
      ),
      label: Text('$key ($defaultVal)'),
      labelStyle: TextStyle(
        fontSize: 11,
        fontWeight: exists ? FontWeight.bold : FontWeight.normal,
        color: exists ? Colors.green.shade900 : colorScheme.onSurface,
      ),
      backgroundColor: exists ? Colors.green.shade50 : colorScheme.surface,
      onPressed: () {
        if (!exists) {
          ref.read(addProductControllerProvider.notifier).addTechSpec(key, defaultVal);
        }
      },
    );
  }
}
