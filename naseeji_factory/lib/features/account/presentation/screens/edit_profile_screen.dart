import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/account_provider.dart';
import '../widgets/account_reusable_widgets.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late FactoryProfileModel _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(accountNotifierProvider).profile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل ملف المصنع'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information
              _sectionCard(
                title: 'المعلومات الأساسية',
                icon: Icons.info_rounded,
                child: _BasicInfoFields(
                  profile: _draft,
                  onNameChanged: (v) => setState(() => _draft = _draft.copyWith(name: v)),
                  onDescriptionChanged: (v) => setState(() => _draft = _draft.copyWith(description: v)),
                ),
              ),
              AppSpacing.hMD,
              // Factory Info
              _sectionCard(
                title: 'معلومات المصنع',
                icon: Icons.factory_rounded,
                child: _FactoryInfoFields(
                  profile: _draft,
                  onTypeChanged: (v) => setState(() => _draft = _draft.copyWith(factoryType: v)),
                  onIndustryChanged: (v) => setState(() => _draft = _draft.copyWith(industry: v)),
                  onCapacityChanged: (v) => setState(() => _draft = _draft.copyWith(productionCapacity: v)),
                ),
              ),
              AppSpacing.hMD,
              // Contact
              _sectionCard(
                title: 'بيانات التواصل',
                icon: Icons.contact_phone_rounded,
                child: _ContactFields(
                  profile: _draft,
                  onPhoneChanged: (v) => setState(() => _draft = _draft.copyWith(phone: v)),
                  onEmailChanged: (v) => setState(() => _draft = _draft.copyWith(email: v)),
                  onWebsiteChanged: (v) => setState(() => _draft = _draft.copyWith(website: v)),
                  onAddressChanged: (v) => setState(() => _draft = _draft.copyWith(address: v)),
                ),
              ),
              AppSpacing.hMD,
              // Documents
              _sectionCard(
                title: 'المستندات الرسمية',
                icon: Icons.description_rounded,
                child: const _DocumentsSection(),
              ),
              AppSpacing.hLG,
              // Actions
              PrimaryButton(
                label: 'حفظ التغييرات',
                icon: Icons.save_rounded,
                onPressed: () {
                  ref.read(accountNotifierProvider.notifier).updateProfile(_draft);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم حفظ التغييرات بنجاح!')),
                  );
                  context.pop();
                },
              ),
              const SizedBox(height: 10),
              SecondaryButton(label: 'إلغاء', onPressed: () => context.pop()),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({required String title, required IconData icon, required Widget child}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF0F766E), size: 20),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F766E))),
              ],
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _BasicInfoFields extends StatelessWidget {
  final FactoryProfileModel profile;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;

  const _BasicInfoFields({required this.profile, required this.onNameChanged, required this.onDescriptionChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _field('اسم المصنع', profile.name, Icons.factory_rounded, onNameChanged),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: profile.description,
          onChanged: onDescriptionChanged,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'وصف المصنع',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _field(String label, String init, IconData icon, ValueChanged<String> fn) {
    return TextFormField(
      initialValue: init,
      onChanged: fn,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      ),
    );
  }
}

class _FactoryInfoFields extends StatelessWidget {
  final FactoryProfileModel profile;
  final ValueChanged<String> onTypeChanged;
  final ValueChanged<String> onIndustryChanged;
  final ValueChanged<String> onCapacityChanged;

  const _FactoryInfoFields({
    required this.profile,
    required this.onTypeChanged,
    required this.onIndustryChanged,
    required this.onCapacityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final types = ['مصنع متكامل', 'مصنع غزل', 'مصنع نسيج', 'مصنع تشطيب', 'مصنع ملابس'];
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: types.contains(profile.factoryType) ? profile.factoryType : types.first,
          items: types.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
          onChanged: (v) => onTypeChanged(v ?? ''),
          decoration: const InputDecoration(labelText: 'نوع المصنع', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: profile.industry,
          onChanged: onIndustryChanged,
          decoration: const InputDecoration(labelText: 'الصناعة', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: profile.productionCapacity,
          onChanged: onCapacityChanged,
          decoration: const InputDecoration(labelText: 'الطاقة الإنتاجية', border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

class _ContactFields extends StatelessWidget {
  final FactoryProfileModel profile;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onWebsiteChanged;
  final ValueChanged<String> onAddressChanged;

  const _ContactFields({
    required this.profile,
    required this.onPhoneChanged,
    required this.onEmailChanged,
    required this.onWebsiteChanged,
    required this.onAddressChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: profile.phone,
          onChanged: onPhoneChanged,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(labelText: 'رقم الهاتف', prefixIcon: Icon(Icons.phone_rounded), border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: profile.email,
          onChanged: onEmailChanged,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'البريد الإلكتروني', prefixIcon: Icon(Icons.email_rounded), border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: profile.website,
          onChanged: onWebsiteChanged,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(labelText: 'الموقع الإلكتروني', prefixIcon: Icon(Icons.language_rounded), border: OutlineInputBorder()),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: profile.address,
          onChanged: onAddressChanged,
          decoration: const InputDecoration(labelText: 'العنوان', prefixIcon: Icon(Icons.place_rounded), border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

class _DocumentsSection extends StatelessWidget {
  const _DocumentsSection();

  @override
  Widget build(BuildContext context) {
    final docs = [
      ('السجل التجاري', Icons.description_rounded, true),
      ('البطاقة الضريبية', Icons.receipt_long_rounded, true),
      ('شهادة ISO', Icons.verified_rounded, false),
      ('شهادات الجودة', Icons.workspace_premium_rounded, false),
    ];
    return Column(
      children: docs.map((d) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Icon(d.$2, size: 22, color: d.$3 ? const Color(0xFF10B981) : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d.$1, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                Text(d.$3 ? 'تم الرفع ✓' : 'لم يُرفع بعد', style: TextStyle(fontSize: 10, color: d.$3 ? const Color(0xFF10B981) : Colors.grey)),
              ]),
            ),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(d.$3 ? 'تحديث' : 'رفع', style: const TextStyle(fontSize: 11)),
            ),
          ],
        ),
      )).toList(),
    );
  }
}
