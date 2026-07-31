import 'package:flutter/material.dart';

class EditProfileLogoCoverSection extends StatelessWidget {
  final String currentLogoUrl;
  final String currentCoverUrl;
  final bool isUploadingLogo;
  final bool isUploadingCover;
  final double logoUploadProgress;
  final double coverUploadProgress;
  final VoidCallback onLogoUpload;
  final VoidCallback onCoverUpload;
  final VoidCallback onLogoRemove;
  final VoidCallback onCoverRemove;

  const EditProfileLogoCoverSection({
    super.key,
    required this.currentLogoUrl,
    required this.currentCoverUrl,
    required this.isUploadingLogo,
    required this.isUploadingCover,
    required this.logoUploadProgress,
    required this.coverUploadProgress,
    required this.onLogoUpload,
    required this.onCoverUpload,
    required this.onLogoRemove,
    required this.onCoverRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E1EF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('شعار وغلاف المنشأة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          SizedBox(height: 12),
          // Cover Image block
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  image: currentCoverUrl.isNotEmpty ? DecorationImage(image: NetworkImage(currentCoverUrl), fit: BoxFit.cover) : null,
                ),
                child: currentCoverUrl.isEmpty ? Center(child: Icon(Icons.image_outlined, size: 30, color: Colors.grey)) : null,
              ),
              if (isUploadingCover)
                Positioned.fill(
                  child: Container(
                    color: Colors.black45,
                    child: Center(
                      child: CircularProgressIndicator(value: coverUploadProgress, color: Colors.white),
                    ),
                  ),
                ),
              Positioned(
                left: 8,
                top: 8,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  radius: 16,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt_outlined, size: 14, color: Color(0xFF0040E0)),
                    padding: EdgeInsets.zero,
                    onPressed: onCoverUpload,
                  ),
                ),
              ),
              if (currentCoverUrl.isNotEmpty)
                Positioned(
                  left: 45,
                  top: 8,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    radius: 16,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, size: 14, color: Colors.red),
                      padding: EdgeInsets.zero,
                      onPressed: onCoverRemove,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          // Logo Block
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('شعار الشركة الرسمي', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                  SizedBox(height: 4),
                  Text('يفضل بصيغة PNG وبأبعاد مربعة 1:1', style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      if (currentLogoUrl.isNotEmpty)
                        SizedBox(
                          width: 90,
                          child: OutlinedButton(
                            onPressed: onLogoRemove,
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                            child: Text('حذف الشعار', style: TextStyle(color: Colors.red, fontSize: 10)),
                          ),
                        ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 90,
                        child: ElevatedButton(
                          onPressed: onLogoUpload,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0040E0), foregroundColor: Colors.white),
                          child: Text('رفع شعار', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 16),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                      image: currentLogoUrl.isNotEmpty ? DecorationImage(image: NetworkImage(currentLogoUrl), fit: BoxFit.cover) : null,
                    ),
                    child: currentLogoUrl.isEmpty ? const Icon(Icons.business_center, size: 24, color: Colors.grey) : null,
                  ),
                  if (isUploadingLogo)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                        child: Center(
                          child: CircularProgressIndicator(value: logoUploadProgress, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}



