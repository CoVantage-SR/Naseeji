import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../providers/otp_provider.dart';
import '../providers/registration_provider.dart';

class OtpHeaderWidget extends ConsumerWidget {
  const OtpHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regState = ref.watch(registrationProvider);
    final phone = regState.phone.isNotEmpty ? regState.phone : '010********';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أدخل رمز التحقق',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.hXS,
        Text(
          'تم إرسال رمز تحقق مكون من 4 أرقام إلى الهاتف $phone. يرجى إدخال الرمز لتأكيد ملكية الحساب.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    );
  }
}

class OtpFieldWidget extends StatefulWidget {
  final ValueChanged<String> onCompleted;

  const OtpFieldWidget({super.key, required this.onCompleted});

  @override
  State<OtpFieldWidget> createState() => _OtpFieldWidgetState();
}

class _OtpFieldWidgetState extends State<OtpFieldWidget> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Auto-select text on focus to allow easy overwrite
    for (int i = 0; i < 4; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String val, int index) {
    if (val.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Last digit, unfocus keyboard
        _focusNodes[index].unfocus();
      }
    } else {
      // User pressed backspace / cleared value
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    
    // Check if code complete
    final code = _controllers.map((c) => c.text).join();
    if (code.length == 4) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 64,
          height: 64,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            onChanged: (val) => _onChanged(val, index),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            textInputAction: index < 3 ? TextInputAction.next : TextInputAction.done,
            maxLength: 1,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: AppRadius.rMD,
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.rMD,
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.rMD,
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class CountdownWidget extends ConsumerWidget {
  const CountdownWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpState = ref.watch(otpVerificationProvider);
    final count = otpState.countdown;

    if (count == 0) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer_outlined, size: 18, color: AppColors.primary),
        AppSpacing.wXS,
        Text(
          'إعادة إرسال الرمز خلال $count ثانية',
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class ResendWidget extends ConsumerWidget {
  const ResendWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpState = ref.watch(otpVerificationProvider);
    final isExpired = otpState.status == OtpStatus.expired || otpState.countdown == 0;

    return Center(
      child: TextButton(
        onPressed: isExpired
            ? () {
                ref.read(otpVerificationProvider.notifier).reset();
              }
            : null,
        child: Text(
          'إعادة إرسال رمز التحقق',
          style: TextStyle(
            color: isExpired ? AppColors.primary : Colors.grey,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

class OtpErrorWidget extends ConsumerWidget {
  const OtpErrorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpState = ref.watch(otpVerificationProvider);
    if (otpState.status != OtpStatus.error) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          otpState.errorMessage,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
