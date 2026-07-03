import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/general_widgets.dart';

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
      'title': 'بيع منتجاتك للمصانع بسهولة',
      'description': 'اعرض منتجاتك وخاماتك ووصل إلى آلاف المصانع في مكان واحد.',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBtag3Lqv4_I_rpM2JUVwYpyG1tW2R399Z3p4YFBighybMRD_S2QK4ib_7u9RXCQ8keWY0-pcp9krIQRMwHQVD1dKyghsR4E0IHBicZsaD-JHtGBctpJY2tDer3zvY8l_8IpQXjsR035ndFB7GhbrzdTZlv_7Xl8d_xF2ofEsjkMay_KS35D7T-0uobWoRmm-yTwtZhrDskE-VDo7zbfHN601u-GUuOc9PW0QfAyyvedt0M2IrKvRCdiSR8Oe_mt5_CLGpLR5B9AHI',
    },
    {
      'title': 'استقبل طلبات المصانع',
      'description': 'تابع طلبات الشراء وعروض الأسعار وتفاوض بسهولة من خلال لوحة تحكم ذكية ومباشرة.',
      'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAqHQvVVmEEq1Y_lLH9lM5ZOWTbR9EgG7PGxsU-b4sAHq7Wip2E4nKk9UzbPbPDMjukEtQupp_QOJGesSO-9qEzmlZh-78Kyb2LTogXXT41tFDDLOTMwKKh6naJknmA2-yhbBMvzKiUcLLJNaEU0VZcwkKuBs5ZWl-8I1qqvXfL9nBoP1mfjsDfI0K6QhIorwiAR5DphGFew50REyd6yj3oBf1TPTl1hhh8wx0ORPtppAQqoqac5KD7hXD3GzBuQXYWxh6KrL86kbE',
    },
    {
      'title': 'إدارة أعمالك بالكامل',
      'description': 'تابع الشحنات والأرباح والفواتير والعملاء من لوحة تحكم واحدة ذكية ومترابطة.',
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button at the top
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft, // Since dir is RTL
                child: TextButton(
                  onPressed: _onSkip,
                  child: const Text(
                    'تخطي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            // Slide contents (PageView)
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
                  return _OnboardingSlide(
                    title: _slides[index]['title']!,
                    description: _slides[index]['description']!,
                    imageUrl: _slides[index]['image']!,
                  );
                },
              ),
            ),
            // Dots indicator
            _OnboardingIndicators(
              count: _slides.length,
              current: _currentPage,
            ),
            const SizedBox(height: 32),
            // Footer control buttons
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
                          side: const BorderSide(color: AppColors.outlineVariant),
                        ),
                        child: const Text(
                          'السابق',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.onBackground,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      text: _currentPage == _slides.length - 1 ? 'ابدأ الآن' : 'التالي',
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
}

class _OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const _OnboardingSlide({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Graphic container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: AppColors.surfaceContainerLow,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback visual icon
                    return Center(
                      child: Icon(
                        Icons.storefront_outlined,
                        size: 96,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _OnboardingIndicators extends StatelessWidget {
  final int count;
  final int current;

  const _OnboardingIndicators({
    required this.count,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: isActive ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.outlineVariant,
            borderRadius: BorderRadius.circular(4.0),
          ),
        );
      }),
    );
  }
}
