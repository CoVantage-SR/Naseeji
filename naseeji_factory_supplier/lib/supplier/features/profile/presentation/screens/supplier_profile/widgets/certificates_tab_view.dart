import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/features/profile/domain/entities/supplier_profile.dart';
import 'package:naseeji_factory/supplier/features/profile/presentation/controllers/profile_controller.dart';

class CertificatesTabView extends ConsumerStatefulWidget {
  final SupplierProfile profile;

  const CertificatesTabView({super.key, required this.profile});

  @override
  ConsumerState<CertificatesTabView> createState() => _CertificatesTabViewState();
}

class _CertificatesTabViewState extends ConsumerState<CertificatesTabView> {
  bool showAddCertForm = false;
  final _certNameController = TextEditingController();
  final _certExpiryController = TextEditingController();
  String uploadedFileName = '';

  @override
  void dispose() {
    _certNameController.dispose();
    _certExpiryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ADD CERTIFICATE CONTAINER
          if (!showAddCertForm)
            Align(
              alignment: Alignment.centerLeft,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showAddCertForm = true;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F4FE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF0040E0), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add_card_outlined, color: Color(0xFF0040E0), size: 16),
                        SizedBox(width: 8),
                        Text(
                          'إضافة شهادة جديدة',
                          style: TextStyle(color: Color(0xFF0040E0), fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0040E0), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('إضافة شهادة أو اعتماد جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0040E0))),
                  SizedBox(height: 12),
                  _buildDialogTextField('اسم الشهادة / الاعتماد', _certNameController),
                  SizedBox(height: 10),
                  _buildDialogTextField('تاريخ انتهاء الصلاحية المتوقع', _certExpiryController),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        uploadedFileName = 'وثيقة_اعتماد_جديدة.pdf';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم اختيار وثيقة الشهادة بنجاح')),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border.all(color: const Color(0xFFE2E1EF), style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            uploadedFileName.isEmpty ? 'اضغط لرفع ملف الشهادة (PDF أو صورة)' : uploadedFileName,
                            style: TextStyle(
                              color: uploadedFileName.isEmpty ? AppColors.outline : const Color(0xFF16A34A),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            uploadedFileName.isEmpty ? Icons.cloud_upload_outlined : Icons.check_circle_outline,
                            color: uploadedFileName.isEmpty ? AppColors.outline : const Color(0xFF16A34A),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 40,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              showAddCertForm = false;
                              _certNameController.clear();
                              _certExpiryController.clear();
                              uploadedFileName = '';
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text('تراجع', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      SizedBox(width: 12),
                      SizedBox(
                        width: 170,
                        height: 40,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (_certNameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('يرجى كتابة اسم الشهادة أولاً')),
                              );
                              return;
                            }
                            
                            // CONNECTED TO DATA & DOMAIN via Controller!
                            await ref.read(profileControllerProvider.notifier).addCertificate(
                              _certNameController.text,
                              _certExpiryController.text,
                            );

                            setState(() {
                              _certNameController.clear();
                              _certExpiryController.clear();
                              uploadedFileName = '';
                              showAddCertForm = false;
                            });
                            
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم إرسال الشهادة للمراجعة والتدقيق بنجاح.')),
                            );
                          },
                          icon: const Icon(Icons.check, size: 14, color: Colors.white),
                          label: Text('حفظ وإرسال للتدقيق', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0040E0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          SizedBox(height: 20),

          // LIST OF CERTIFICATES
          Text('الشهادات الحالية المعتمدة والموثقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          ...widget.profile.certificates.map((cert) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E1EF)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                children: [
                  // Action Download button in a circular container
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F4FE),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.download_rounded, color: Color(0xFF0040E0), size: 18),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('جاري تحميل ملف الاعتماد الرسمي...')),
                        );
                      },
                    ),
                  ),
                  const Spacer(),
                  // Certificate details
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cert.name,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          textAlign: TextAlign.end,
                        ),
                        SizedBox(height: 4),
                        Text(
                          cert.date,
                          style: TextStyle(fontSize: 9, color: AppColors.outline),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  // Premium verification badge (Pill shape)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: cert.verified ? const Color(0xFFE2F9F5) : const Color(0xFFFFF4EB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          cert.verified ? 'مُوثقة' : 'تحت التدقيق',
                          style: TextStyle(
                            color: cert.verified ? const Color(0xFF006B5F) : Colors.orange,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          cert.verified ? Icons.check_circle_outline : Icons.pending_outlined,
                          color: cert.verified ? const Color(0xFF006B5F) : Colors.orange,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDialogTextField(String label, TextEditingController ctrl) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 11),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}


