import 'package:flutter/material.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/validators/validators.dart';

class LoginForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneOrEmailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.phoneOrEmailController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final FocusNode _phoneOrEmailFocusNode;
  late final FocusNode _passwordFocusNode;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _phoneOrEmailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _phoneOrEmailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Field 1: Email or Phone
          _FormInputLabel(label: l10n.emailOrPhoneLabel),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.phoneOrEmailController,
            focusNode: _phoneOrEmailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            autofillHints: const [
              AutofillHints.email,
              AutofillHints.telephoneNumber,
              AutofillHints.username,
            ],
            style: theme.textTheme.bodyLarge,
            decoration: _buildInputDecoration(
              context: context,
              hintText: l10n.emailOrPhoneHint,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            validator: Validators.emailOrPhone,
          ),

          AppSpacing.hMD,

          // Field 2: Password
          _FormInputLabel(label: l10n.passwordLabel),
          const SizedBox(height: 6),
          TextFormField(
            controller: widget.passwordController,
            focusNode: _passwordFocusNode,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) {
              if (!widget.isLoading) {
                widget.onLogin();
              }
            },
            autofillHints: const [AutofillHints.password],
            style: theme.textTheme.bodyLarge,
            decoration: _buildInputDecoration(
              context: context,
              hintText: l10n.passwordHint,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    key: ValueKey<bool>(_obscurePassword),
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: Validators.password,
          ),

          const SizedBox(height: 8),

          // Remember Me & Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remember me
              Semantics(
                button: true,
                checked: widget.rememberMe,
                label: l10n.rememberMe,
                child: InkWell(
                  onTap: () => widget.onRememberMeChanged(!widget.rememberMe),
                  borderRadius: AppRadius.rSM,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: widget.rememberMe,
                            onChanged: (val) => widget.onRememberMeChanged(val ?? false),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            activeColor: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.rememberMe,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Forgot password button
              Semantics(
                button: true,
                label: l10n.forgotPassword,
                child: SizedBox(
                  height: 48,
                  child: TextButton(
                    onPressed: widget.onForgotPassword,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(48, 48),
                    ),
                    child: Text(
                      l10n.forgotPassword,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          AppSpacing.hLG,

          // Primary Login Button
          Semantics(
            button: true,
            enabled: !widget.isLoading,
            label: l10n.loginButton,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : widget.onLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.rMD,
                  ),
                ),
                child: widget.isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        l10n.loginButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        fontSize: 13,
      ),
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.rMD,
        borderSide: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.rMD,
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.rMD,
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.rMD,
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1.5,
        ),
      ),
    );
  }
}

class _FormInputLabel extends StatelessWidget {
  final String label;

  const _FormInputLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
        fontSize: 13.5,
      ),
    );
  }
}
