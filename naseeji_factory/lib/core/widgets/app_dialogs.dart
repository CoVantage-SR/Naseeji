import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../extensions/context_extensions.dart';

class AppDialogs {
  AppDialogs._();

  static Future<T?> showAppDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text(
              content,
              style: context.textTheme.bodyMedium,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.rMD,
            ),
            actions: <Widget>[
              if (cancelText != null)
                TextButton(
                  onPressed: onCancel ?? () => Navigator.of(context).pop(),
                  child: Text(
                    cancelText,
                    style: TextStyle(color: AppColors.textSecondaryLight),
                  ),
                ),
              TextButton(
                onPressed: onConfirm ?? () => Navigator.of(context).pop(),
                child: Text(
                  confirmText ?? 'موافق',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<T?> showAppBottomSheet<T>({
    required BuildContext context,
    required Widget child,
    String? title,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderLight,
                      borderRadius: AppRadius.rRound,
                    ),
                  ),
                ),
                if (title != null) ...[
                  AppSpacing.hMD,
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                ],
                AppSpacing.hSM,
                Flexible(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}
