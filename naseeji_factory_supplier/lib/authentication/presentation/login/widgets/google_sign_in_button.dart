import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../l10n/app_localizations.dart';
import 'naseeji_logo_painters.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      enabled: !isLoading,
      label: l10n.googleSignIn,
      hint: l10n.googleSignIn,
      child: SizedBox(
        height: 50,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            backgroundColor: colorScheme.surfaceContainerLow,
            foregroundColor: colorScheme.onSurface,
            side: BorderSide(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.rMD,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.primary,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const GoogleLogoPainterWidget(size: 20),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        l10n.googleSignIn,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
