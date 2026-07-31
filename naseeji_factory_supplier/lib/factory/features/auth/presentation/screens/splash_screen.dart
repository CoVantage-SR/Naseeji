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
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              Color(0xFF0C625B), // Darker brand teal
              Color(0xFF06332F), // Deep industrial teal/slate
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const SafeArea(
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
      ),
    );
  }
}


