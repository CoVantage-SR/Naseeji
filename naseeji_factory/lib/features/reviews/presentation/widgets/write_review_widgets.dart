import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/extensions/context_extensions.dart';

// ─── Text Editor Widget ────────────────────────────────────────────────────
class TextEditorWidget extends StatelessWidget {
  final String text;
  final ValueChanged<String> onChanged;
  const TextEditorWidget({super.key, required this.text, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'كتابة تقييم تفصيلي',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 6),
            const Text(
              'شارك تجربتك بالتفصيل لمساعدة المصانع الأخرى على اتخاذ قرار أفضل.',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: onChanged,
              maxLines: 8,
              maxLength: 1000,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'اكتب تقييمك هنا... (الجودة، الالتزام، التسليم، الخدمة...)',
                hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: AppRadius.rSM),
                contentPadding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Media Uploader Widget ─────────────────────────────────────────────────
class MediaUploaderWidget extends StatelessWidget {
  final List<String> images;
  final List<String> videos;
  final VoidCallback onUploadImage;
  final VoidCallback onUploadVideo;
  final Function(int) onRemoveImage;
  final Function(int) onRemoveVideo;
  const MediaUploaderWidget({
    super.key,
    required this.images,
    required this.videos,
    required this.onUploadImage,
    required this.onUploadVideo,
    required this.onRemoveImage,
    required this.onRemoveVideo,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إرفاق صور ومرئيات',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            // Upload buttons row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onUploadImage,
                    icon: const Icon(Icons.camera_alt_rounded, size: 16),
                    label: const Text('إرفاق صور', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onUploadVideo,
                    icon: const Icon(Icons.videocam_rounded, size: 16),
                    label: const Text('إرفاق فيديو', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                    ),
                  ),
                ),
              ],
            ),
            // Image previews
            if (images.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (_, i) => Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ClipRRect(
                          borderRadius: AppRadius.rSM,
                          child: Image.network(
                            images[i],
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_rounded),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => onRemoveImage(i),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Visibility Widget ─────────────────────────────────────────────────────
class VisibilityWidget extends StatelessWidget {
  final bool isPublic;
  final ValueChanged<bool> onChanged;
  const VisibilityWidget({super.key, required this.isPublic, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'خصوصية التقييم',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _visOption(
                    icon: Icons.public_rounded,
                    label: 'تقييم عام',
                    desc: 'يظهر لجميع المصانع',
                    color: AppColors.success,
                    isSelected: isPublic,
                    onTap: () => onChanged(true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _visOption(
                    icon: Icons.lock_rounded,
                    label: 'تقييم خاص',
                    desc: 'للمورد فقط',
                    color: Colors.grey,
                    isSelected: !isPublic,
                    onTap: () => onChanged(false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _visOption({
    required IconData icon,
    required String label,
    required String desc,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: AppRadius.rSM,
          border: Border.all(
            color: isSelected ? color : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? color : Colors.grey)),
            Text(desc, style: const TextStyle(fontSize: 9, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─── Write Review Submit Widget ────────────────────────────────────────────
class WriteReviewSubmitWidget extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final bool isEnabled;
  const WriteReviewSubmitWidget({
    super.key,
    required this.onSubmit,
    required this.onCancel,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isEnabled ? onSubmit : null,
            icon: const Icon(Icons.star_rounded, size: 18),
            label: const Text('نشر التقييم', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onCancel,
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
