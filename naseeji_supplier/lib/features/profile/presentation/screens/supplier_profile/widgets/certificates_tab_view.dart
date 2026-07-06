import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/profile/domain/entities/supplier_profile.dart';
import 'package:naseeji_supplier/features/profile/presentation/controllers/profile_controller.dart';

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
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    showAddCertForm = true;
                  });
                },
                icon: const Icon(Icons.add_card_outlined, color: Color(0xFF0040E0), size: 16),
                label: const Text('إضافة شهادة جديدة', style: TextStyle(color: Color(0xFF0040E0), fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0040E0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF0040E0), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('إضافة شهادة أو اعتماد جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0040E0))),
                  const SizedBox(height: 12),
                  _buildDialogTextField('اسم الشهادة / الاعتماد', _certNameController),
                  const SizedBox(height: 10),
                  _buildDialogTextField('تاريخ انتهاء الصلاحية المتوقع', _certExpiryController),
                  const SizedBox(height: 12),
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
                        color: const Color(0xFFF8F9FF),
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
                          const SizedBox(width: 8),
                          Icon(
                            uploadedFileName.isEmpty ? Icons.cloud_upload_outlined : Icons.check_circle_outline,
                            color: uploadedFileName.isEmpty ? AppColors.outline : const Color(0xFF16A34A),
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
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
                          child: const Text('تراجع', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                          label: const Text('حفظ وإرسال للتدقيق', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
          const SizedBox(height: 20),

          // LIST OF CERTIFICATES
          const Text('الشهادات الحالية المعتمدة والموثقة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          ...widget.profile.certificates.map((cert) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE2E1EF))),
              color: Colors.white,
              child: ListTile(
                title: Text(cert.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                subtitle: Text(cert.date, style: const TextStyle(fontSize: 9, color: AppColors.outline), textAlign: TextAlign.end),
                trailing: Icon(cert.verified ? Icons.check_circle_outline : Icons.pending_outlined, color: cert.verified ? const Color(0xFF16A34A) : Colors.orange, size: 20),
                leading: IconButton(
                  icon: const Icon(Icons.download_rounded, color: Color(0xFF0040E0), size: 18),
                  onPressed: () {},
                ),
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
          labelStyle: const TextStyle(fontSize: 11),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
