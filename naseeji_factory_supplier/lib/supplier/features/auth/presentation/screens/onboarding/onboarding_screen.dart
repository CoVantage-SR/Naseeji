import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/widgets/general_widgets.dart';
import 'widgets/onboarding_slide.dart';
import 'widgets/onboarding_indicators.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'بيع حاجتك للمصانع بكل سهولة',
      'description': 'اعرض منتجاتك وخاماتك ووصل لآلاف المصانع في حتة واحدة.',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBtag3Lqv4_I_rpM2JUVwYpyG1tW2R399Z3p4YFBighybMRD_S2QK4ib_7u9RXCQ8keWY0-pcp9krIQRMwHQVD1dKyghsR4E0IHBicZsaD-JHtGBctpJY2tDer3zvY8l_8IpQXjsR035ndFB7GhbrzdTZlv_7Xl8d_xF2ofEsjkMay_KS35D7T-0uobWoRmm-yTwtZhrDskE-VDo7zbfHN601u-GUuOc9PW0QfAyyvedt0M2IrKvRCdiSR8Oe_mt5_CLGpLR5B9AHI',
    },
    {
      'title': 'استقبل طلبات المصانع علطول',
      'description': 'تابع طلبات الشراء وعروض الأسعار واتفاوض براحتك من لوحة تحكم ذكية وسهلة.',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAqHQvVVmEEq1Y_lLH9lM5ZOWTbR9EgG7PGxsU-b4sAHq7Wip2E4nKk9UzbPbPDMjukEtQupp_QOJGesSO-9qEzmlZh-78Kyb2LTogXXT41tFDDLOTMwKKh6naJknmA2-yhbBMvzKiUcLLJNaEU0VZcwkKuBs5ZWl-8I1qqvXfL9nBoP1mfjsDfI0K6QhIorwiAR5DphGFew50REyd6yj3oBf1TPTl1hhh8wx0ORPtppAQqoqac5KD7hXD3GzBuQXYWxh6KrL86kbE',
    },
    {
      'title': 'إدارة شغلك كله من مكان واحد',
      'description': 'تابع شحناتك وأرباحك وفواتيرك وعملائك من مكان واحد متكامل.',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAqHQvVVmEEq1Y_lLH9lM5ZOWTbR9EgG7PGxsU-b4sAHq7Wip2E4nKk9UzbPbPDMjukEtQupp_QOJGesSO-9qEzmlZh-78Kyb2LTogXXT41tFDDLOTMwKKh6naJknmA2-yhbBMvzKiUcLLJNaEU0VZcwkKuBs5ZWl-8I1qqvXfL9nBoP1mfjsDfI0K6QhIorwiAR5DphGFew50REyd6yj3oBf1TPTl1hhh8wx0ORPtppAQqoqac5KD7hXD3GzBuQXYWxh6KrL86kbE',
    }
  ];

  void _onNext() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/supplier-type');
    }
  }

  void _onSkip() {
    context.go('/supplier-type');
  }

  void _onPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.darkTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _onSkip,
                        child: Text(
                          'عدّي',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: _slides.length,
                      itemBuilder: (context, index) {
                        return OnboardingSlide(
                          title: _slides[index]['title']!,
                          description: _slides[index]['description']!,
                          imageUrl: _slides[index]['image']!,
                        );
                      },
                    ),
                  ),
                  OnboardingIndicators(
                    count: _slides.length,
                    current: _currentPage,
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Row(
                      children: [
                        if (_currentPage > 0) ...[
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: _onPrevious,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                              ),
                              child: Text(
                                'اللي فات',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                        Expanded(
                          flex: 2,
                          child: PrimaryButton(
                            text: _currentPage == _slides.length - 1 ? 'ابدأ دلوقتي' : 'اللي بعده',
                            onPressed: _onNext,
                            suffixIcon: _currentPage == _slides.length - 1
                                ? Icons.rocket_launch
                                : Icons.arrow_forward_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}




