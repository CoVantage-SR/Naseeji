import 'package:flutter/material.dart';

@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  final Color success;
  final Color successContainer;
  final Color warning;
  final Color warningContainer;
  final Color info;
  final Color infoContainer;
  final Color error;
  final Color errorContainer;

  final Color draft;
  final Color draftContainer;
  final Color pending;
  final Color pendingContainer;
  final Color negotiating;
  final Color negotiatingContainer;
  final Color completed;
  final Color completedContainer;
  final Color cancelled;
  final Color cancelledContainer;

  const AppStatusColors({
    required this.success,
    required this.successContainer,
    required this.warning,
    required this.warningContainer,
    required this.info,
    required this.infoContainer,
    required this.error,
    required this.errorContainer,
    required this.draft,
    required this.draftContainer,
    required this.pending,
    required this.pendingContainer,
    required this.negotiating,
    required this.negotiatingContainer,
    required this.completed,
    required this.completedContainer,
    required this.cancelled,
    required this.cancelledContainer,
  });

  static const light = AppStatusColors(
    success: Color(0xFF16A34A),
    successContainer: Color(0xFFDCFCE7),
    warning: Color(0xFFEA580C),
    warningContainer: Color(0xFFFFF7ED),
    info: Color(0xFF2563EB),
    infoContainer: Color(0xFFEFF6FF),
    error: Color(0xFFDC2626),
    errorContainer: Color(0xFFFEF2F2),
    draft: Color(0xFF6B7280),
    draftContainer: Color(0xFFF3F4F6),
    pending: Color(0xFFD97706),
    pendingContainer: Color(0xFFFEF3C7),
    negotiating: Color.fromARGB(255, 63, 51, 234),
    negotiatingContainer: Color.fromARGB(255, 215, 209, 241),
    completed: Color(0xFF16A34A), 
    completedContainer: Color(0xFFDCFCE7),
    cancelled: Color(0xFFEF4444),
    cancelledContainer: Color(0xFFFEE2E2),
  );

  static const dark = AppStatusColors(
    success: Color(0xFF4ADE80),
    successContainer: Color(0xFF14532D),
    warning: Color(0xFFFB923C),
    warningContainer: Color(0xFF7C2D12),
    info: Color(0xFF60A5FA),
    infoContainer: Color(0xFF1E3A8A),
    error: Color(0xFFF87171),
    errorContainer: Color(0xFF7F1D1D),
    draft: Color(0xFF9CA3AF),
    draftContainer: Color(0xFF374151),
    pending: Color(0xFFFBBF24),
    pendingContainer: Color(0xFF78350F),
    negotiating: Color.fromARGB(255, 95, 114, 240),
    negotiatingContainer: Color.fromARGB(255, 215, 209, 241) ,
    completed: Color(0xFF4ADE80),
    completedContainer: Color(0xFF14532D),
    cancelled: Color(0xFFF87171),
    cancelledContainer: Color(0xFF7F1D1D),
  );

  @override
  AppStatusColors copyWith({
    Color? success,
    Color? successContainer,
    Color? warning,
    Color? warningContainer,
    Color? info,
    Color? infoContainer,
    Color? error,
    Color? errorContainer,
    Color? draft,
    Color? draftContainer,
    Color? pending,
    Color? pendingContainer,
    Color? negotiating,
    Color? negotiatingContainer,
    Color? completed,
    Color? completedContainer,
    Color? cancelled,
    Color? cancelledContainer,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      error: error ?? this.error,
      errorContainer: errorContainer ?? this.errorContainer,
      draft: draft ?? this.draft,
      draftContainer: draftContainer ?? this.draftContainer,
      pending: pending ?? this.pending,
      pendingContainer: pendingContainer ?? this.pendingContainer,
      negotiating: negotiating ?? this.negotiating,
      negotiatingContainer: negotiatingContainer ?? this.negotiatingContainer,
      completed: completed ?? this.completed,
      completedContainer: completedContainer ?? this.completedContainer,
      cancelled: cancelled ?? this.cancelled,
      cancelledContainer: cancelledContainer ?? this.cancelledContainer,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorContainer: Color.lerp(errorContainer, other.errorContainer, t)!,
      draft: Color.lerp(draft, other.draft, t)!,
      draftContainer: Color.lerp(draftContainer, other.draftContainer, t)!,
      pending: Color.lerp(pending, other.pending, t)!,
      pendingContainer: Color.lerp(pendingContainer, other.pendingContainer, t)!,
      negotiating: Color.lerp(negotiating, other.negotiating, t)!,
      negotiatingContainer: Color.lerp(negotiatingContainer, other.negotiatingContainer, t)!,
      completed: Color.lerp(completed, other.completed, t)!,
      completedContainer: Color.lerp(completedContainer, other.completedContainer, t)!,
      cancelled: Color.lerp(cancelled, other.cancelled, t)!,
      cancelledContainer: Color.lerp(cancelledContainer, other.cancelledContainer, t)!,
    );
  }
}

extension AppThemeContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  AppStatusColors get statusColors =>
      Theme.of(this).extension<AppStatusColors>() ?? (isDarkMode ? AppStatusColors.dark : AppStatusColors.light);
}
