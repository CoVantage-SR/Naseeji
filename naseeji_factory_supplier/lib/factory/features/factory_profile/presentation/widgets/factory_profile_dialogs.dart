import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../domain/entities/factory_profile_entities.dart';
import '../providers/factory_profile_provider.dart';

class EditBasicFieldSheet extends ConsumerStatefulWidget {
  final String fieldName;
  final String currentValue;

  const EditBasicFieldSheet({
    super.key,
    required this.fieldName,
    required this.currentValue,
  });

  @override
  ConsumerState<EditBasicFieldSheet> createState() => _EditBasicFieldSheetState();
}

class _EditBasicFieldSheetState extends ConsumerState<EditBasicFieldSheet> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState() ;
    _controller = TextEditingController(text: widget.currentValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('تعديل ${widget.fieldName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: _controller,
            maxLines: widget.fieldName == 'نبذة عن المصنع' ? 4 : 1,
            decoration: InputDecoration(
              labelText: widget.fieldName,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            ),
            onPressed: () {
              final state = ref.read(factoryProfileProvider);
              final p = state.profile;
              final val = _controller.text.trim();

              FactoryProfileEntity updated = p;
              if (widget.fieldName == 'اسم المصنع') updated = p.copyWith(name: val);
              if (widget.fieldName == 'نوع المصنع') updated = p.copyWith(factoryType: val);
              if (widget.fieldName == 'السجل التجاري') updated = p.copyWith(commercialRegister: val);
              if (widget.fieldName == 'الرقم الضريبي') updated = p.copyWith(taxNumber: val);
              if (widget.fieldName == 'البطاقة الضريبية') updated = p.copyWith(vatNumber: val);
              if (widget.fieldName == 'تاريخ تأسيس المصنع') updated = p.copyWith(establishmentDate: val);
              if (widget.fieldName == 'نبذة عن المصنع') updated = p.copyWith(description: val);

              ref.read(factoryProfileProvider.notifier).updateProfile(updated);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم تحديث ${widget.fieldName} بنجاح!')),
              );
            },
            child: const Text('حفظ التعديلات', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class UploadDocumentSheet extends ConsumerStatefulWidget {
  const UploadDocumentSheet({super.key});

  @override
  ConsumerState<UploadDocumentSheet> createState() => _UploadDocumentSheetState();
}

class _UploadDocumentSheetState extends ConsumerState<UploadDocumentSheet> {
  final _titleController = TextEditingController();
  final _numController = TextEditingController();
  final _expiryController = TextEditingController(text: '2027/12/31');
  String _selectedType = 'البطاقة الضريبية';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('إضافة مستند ترخيص جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'نوع المستند', border: OutlineInputBorder()),
            items: const [
              DropdownMenuItem(value: 'البطاقة الضريبية', child: Text('البطاقة الضريبية')),
              DropdownMenuItem(value: 'السجل التجاري', child: Text('السجل التجاري')),
              DropdownMenuItem(value: 'شهادة ضريبة القيمة المضافة', child: Text('شهادة ضريبة القيمة المضافة')),
              DropdownMenuItem(value: 'شهادة ISO 9001', child: Text('شهادة ISO 9001')),
              DropdownMenuItem(value: 'رخصة الاستيراد والتصدير', child: Text('رخصة الاستيراد والتصدير')),
            ],
            onChanged: (val) => setState(() => _selectedType = val!),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'اسم/عنوان المستند (مثال: رخصة التشغيل الصناعي)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _numController,
            decoration: const InputDecoration(labelText: 'رقم المستند/الشهادة', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: _expiryController,
            decoration: const InputDecoration(labelText: 'تاريخ الانتهاء', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            ),
            onPressed: () {
              if (_titleController.text.trim().isNotEmpty) {
                final doc = FactoryDocumentEntity(
                  id: 'DOC-${DateTime.now().millisecondsSinceEpoch.toString().substring(9)}',
                  title: _titleController.text.trim(),
                  documentNumber: _numController.text.trim().isEmpty ? 'DOC-100' : _numController.text.trim(),
                  documentType: _selectedType,
                  status: 'سارية',
                  expiryDate: _expiryController.text.trim(),
                  fileUrl: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
                  version: 1,
                );
                ref.read(factoryProfileProvider.notifier).addDocument(doc);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم إضافة المستند "${doc.title}" بنجاح!')),
                );
              }
            },
            child: const Text('رفع وحفظ المستند', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class ChangeLogoDialog extends StatefulWidget {
  final ValueChanged<String> onConfirm;

  const ChangeLogoDialog({super.key, required this.onConfirm});

  @override
  State<ChangeLogoDialog> createState() => _ChangeLogoDialogState();
}

class _ChangeLogoDialogState extends State<ChangeLogoDialog> {
  final _urlController = TextEditingController(text: 'https://images.unsplash.com/photo-1541888946425-d0fbb186a5b3?w=300');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تغيير شعار المصنع'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('قم بإدخال رابط الصورة الجديدة لشعار المصنع أو رفعها:'),
          const SizedBox(height: 10),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(labelText: 'رابط الصورة (URL)', border: OutlineInputBorder()),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: () {
            widget.onConfirm(_urlController.text.trim());
            Navigator.pop(context);
          },
          child: const Text('حفظ الشعار', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class DeleteFactoryDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteFactoryDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تأكيد حذف ملف المصنع'),
      content: const Text('هل أنت متأكد من رغبتك في حذف ملف المصنع؟ هذا الإجراء سيؤدي إلى تجميد جميع المعاملات والعروض والمنتجات.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('تأكيد الحذف النهائي', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}


