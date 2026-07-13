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
      'image': 'https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?q=80&w=600&auto=format&fit=crop',
      'label': 'البحث عن موردين',
      'title': 'ابحث عن أفضل موردي المنسوجات',
      'description': 'سهولة تامة في البحث عن شركات وموردي الغزل والأقمشة ومستلزمات الإنتاج وتوسيع شبكة أعمالك.',
    },
    {
      'icon': Icons.handshake_rounded,
      'image': 'https://images.unsplash.com/photo-1573164713714-d95e436ab8d6?q=80&w=600&auto=format&fit=crop',
      'label': 'التفاوض والتعاقد',
      'title': 'قدم عروض أسعار وتفاوض مباشرة',
      'description': 'أرسل طلبات عروض الأسعار (RFQ) وتفاوض على الأسعار وشروط الدفع والتعاقد بشكل فوري وآمن.',
    },
    {
      'icon': Icons.local_shipping_rounded,
      'image': 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=600&auto=format&fit=crop',
      'label': 'تتبع الشحنات والطلبات',
      'title': 'تتبع شحناتك وخط الإنتاج',
      'description': 'شاهد حالة خطوط الإنتاج والطلبات ومواعيد التسليم خطوة بخطوة حتى تصل الشحنة لباب مصنعك.',
    },
  ];

  void _onNext() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _currentIndex < _slides.length - 1 ? 1.0 : 0.0,
                  child: IgnorePointer(
                    ignoring: _currentIndex >= _slides.length - 1,
                    child: SkipButtonWidget(
                      onPressed: () => context.go('/login'),
                    ),
                  ),
                ),
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
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          OnboardingImageWidget(
                            imageUrl: slide['image'],
                            fallbackIcon: slide['icon'],
                            label: slide['label'],
                          ),
                          AppSpacing.hXL,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: OnboardingTitleWidget(title: slide['title']),
                          ),
                          AppSpacing.hMD,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: OnboardingDescriptionWidget(description: slide['description']),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ProgressIndicatorWidget(
                count: _slides.length,
                currentIndex: _currentIndex,
              ),
              AppSpacing.hXL,
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
