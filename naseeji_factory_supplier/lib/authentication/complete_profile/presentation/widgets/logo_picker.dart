import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LogoPicker extends StatelessWidget {
  final XFile? selectedLogo;
  final String? logoUrl;
  final Function(ImageSource source) onPickImage;
  final VoidCallback onDeleteImage;

  const LogoPicker({
    super.key,
    this.selectedLogo,
    this.logoUrl,
    required this.onPickImage,
    required this.onDeleteImage,
  });

  void _showPickerModal(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'اختيار شعار الشركة',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.photo_library_outlined,
                        color: colorScheme.primary),
                  ),
                  title: const Text('المعرض'),
                  subtitle: const Text('اختر صورة من البوم الصور'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.secondaryContainer,
                    child: Icon(Icons.camera_alt_outlined,
                        color: colorScheme.secondary),
                  ),
                  title: const Text('الكاميرا'),
                  subtitle: const Text('التقط صورة جديدة مباشرة'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickImage(ImageSource.camera);
                  },
                ),
                if (selectedLogo != null || (logoUrl != null && logoUrl!.isNotEmpty)) ...[
                  const Divider(),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.errorContainer,
                      child: Icon(Icons.delete_outline,
                          color: colorScheme.error),
                    ),
                    title: Text(
                      'حذف الشعار',
                      style: TextStyle(color: colorScheme.error),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      onDeleteImage();
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final hasImage = selectedLogo != null || (logoUrl != null && logoUrl!.isNotEmpty);

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark
                  ? colorScheme.surfaceContainerHighest
                  : const Color(0xFFF1F5F9),
              border: Border.all(
                color: hasImage ? colorScheme.primary : colorScheme.outline,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: _buildImageContent(colorScheme),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () => _showPickerModal(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  hasImage ? Icons.edit_rounded : Icons.add_a_photo_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContent(ColorScheme colorScheme) {
    if (selectedLogo != null) {
      return Image.file(
        File(selectedLogo!.path),
        fit: BoxFit.cover,
        width: 110,
        height: 110,
      );
    }

    if (logoUrl != null && logoUrl!.isNotEmpty) {
      if (logoUrl!.startsWith('http')) {
        return Image.network(
          logoUrl!,
          fit: BoxFit.cover,
          width: 110,
          height: 110,
          errorBuilder: (_, __, ___) => _buildPlaceholder(colorScheme),
        );
      }
      return Image.file(
        File(logoUrl!),
        fit: BoxFit.cover,
        width: 110,
        height: 110,
        errorBuilder: (_, __, ___) => _buildPlaceholder(colorScheme),
      );
    }

    return _buildPlaceholder(colorScheme);
  }

  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.business_rounded,
          size: 38,
          color: colorScheme.primary.withValues(alpha: 0.7),
        ),
        const SizedBox(height: 4),
        Text(
          'شعار الشركة',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
