import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/profile/domain/entities/supplier_profile.dart';

class PublicCertificatesTabView extends StatelessWidget {
  final SupplierProfile profile;

  const PublicCertificatesTabView({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: profile.certificates.length,
      itemBuilder: (context, index) {
        final cert = profile.certificates[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cert.verified ? const Color(0xFF006B5F).withValues(alpha: 0.2) : const Color(0xFFE2E1EF),
              width: cert.verified ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              // Download certificate action
              IconButton(
                icon: const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF0040E0), size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('جاري فتح وثيقة الاعتماد الرسمية...')),
                  );
                },
              ),
              const Spacer(),
              // Title & Date info
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      cert.name,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Theme.of(context).colorScheme.onSurface),
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
              // Verified status badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cert.verified ? const Color(0xFFE2F9F5) : const Color(0xFFFFF4EB),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  cert.verified ? Icons.verified_user_outlined : Icons.hourglass_empty_outlined,
                  color: cert.verified ? const Color(0xFF006B5F) : Colors.orange,
                  size: 18,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
