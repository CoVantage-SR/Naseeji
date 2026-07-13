import 'package:flutter/material.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_logo.dart';

class SplashLogoWidget extends StatelessWidget {
  final double size;
  const SplashLogoWidget({super.key, this.size = 80.0});

  @override
  Widget build(BuildContext context) {
    return AppLogo(
      size: size,
      showText: false,
      color: Colors.white,
    );
  }
}

class SplashTitleWidget extends StatelessWidget {
  const SplashTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'مصنع نسيجي',
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class SplashSubtitleWidget extends StatelessWidget {
  const SplashSubtitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'المنصة الصناعية لقطاع الغزل والنسيج',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
    );
  }
}

class SplashAnimationWidget extends StatefulWidget {
  final Widget child;
  const SplashAnimationWidget({super.key, required this.child});

  @override
  State<SplashAnimationWidget> createState() => _SplashAnimationWidgetState();
}

class _SplashAnimationWidgetState extends State<SplashAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}

class SplashFooterWidget extends StatelessWidget {
  const SplashFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 140,
          child: LinearProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.white24,
          ),
        ),
        AppSpacing.hMD,
        Text(
          'نسخة التجريبية MVP v1.0.0',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white38,
              ),
        ),
      ],
    );
  }
}
