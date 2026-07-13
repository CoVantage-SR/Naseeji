import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../widgets/splash_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              Spacer(),
              SplashAnimationWidget(
                child: Column(
                  children: [
                    SplashLogoWidget(),
                    AppSpacing.hMD,
                    SplashTitleWidget(),
                    AppSpacing.hXS,
                    SplashSubtitleWidget(),
                  ],
                ),
              ),
              Spacer(),
              SplashFooterWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
