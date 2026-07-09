import 'dart:async';
import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class OtpTimer extends StatefulWidget {
  final Future<bool> Function() onResend;

  const OtpTimer({
    super.key,
    required this.onResend,
  });

  @override
  State<OtpTimer> createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;
    final success = await widget.onResend();
    if (success && mounted) {
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _canResend ? 'لم تستلم الرمز؟ ' : 'يمكنك إعادة إرسال الرمز خلال ',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
        if (_canResend)
          GestureDetector(
            onTap: _handleResend,
            child: Text(
              'إعادة الإرسال',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          Text(
            '00:$_secondsRemaining',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }
}
