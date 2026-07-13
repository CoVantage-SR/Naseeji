import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../widgets/onboarding_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'icon': Icons.search_rounded,
      'label': 'البحث عن موردين',
      'title': 'ابحث عن أفضل موردي المنسوجات',
      'description': 'سهولة تامة في البحث عن شركات وموردي الغزل والأقمشة ومستلزمات الإنتاج وتوسيع شبكة أعمالك.',
    },
    {
      'icon': Icons.handshake_rounded,
      'label': 'التفاوض والتعاقد',
      'title': 'قدم عروض أسعار وتفاوض مباشرة',
      'description': 'أرسل طلبات عروض الأسعار (RFQ) وتفاوض على الأسعار وشروط الدفع والتعاقد بشكل فوري وآمن.',
    },
    {
      'icon': Icons.local_shipping_rounded,
      'label': 'تتبع الشحنات والطلبات',
      'title': 'تتبع شحناتك وخط الإنتاج',
      'description': 'شاهد حالة خطوط الإنتاج والطلبات ومواعيد التسليم خطوة بخطوة حتى تصل الشحنة لباب مصنعك.',
    },
  ];

  void _onNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _currentIndex < _slides.length - 1
                    ? SkipButtonWidget(onPressed: () => context.go('/login'))
                    : const SizedBox(height: 48), // Spacer to maintain layout
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OnboardingImageWidget(
                          icon: slide['icon'],
                          label: slide['label'],
                        ),
                        AppSpacing.hLG,
                        OnboardingTitleWidget(title: slide['title']),
                        AppSpacing.hMD,
                        OnboardingDescriptionWidget(description: slide['description']),
                      ],
                    );
                  },
                ),
              ),
              ProgressIndicatorWidget(
                count: _slides.length,
                currentIndex: _currentIndex,
              ),
              AppSpacing.hLG,
              NextButtonWidget(
                text: _currentIndex == _slides.length - 1 ? 'ابدأ الآن' : 'التالي',
                onPressed: _onNext,
              ),
              AppSpacing.hMD,
            ],
          ),
        ),
      ),
    );
  }
}
