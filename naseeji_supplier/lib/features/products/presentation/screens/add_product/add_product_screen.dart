import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form values
  final _nameController = TextEditingController(text: 'قطن مصري فاخر 100%');
  final _descController = TextEditingController();
  String _selectedCategory = 'خيوط طبيعية';
  String _productNature = 'تجزئة'; // or 'صناعي'
  bool _availableForDirectOrder = true;
  
  int _charCount = 0;

  final List<String> _categories = [
    'خيوط طبيعية',
    'أقمشة قطنية',
    'حرير طبيعي',
    'منسوجات صناعية',
  ];

  @override
  void initState() {
    super.initState();
    _descController.addListener(() {
      setState(() {
        _charCount = _descController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Naseeji',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
              backgroundImage: const NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAwdcc7_JG_FpqYPM_3USUy2u_gX1xKNh2O8AjHeN4bAASsFm6R57Bjz0ZoPFzPuZ3eLTSvU9sIMlKh4KRg0KUdRf1du2ZHmrdK4tLNeHYfj7tGOSiCQlVfUFElxH3MFUEnGUWFYEyBQuCNm7QAvcuFhXI9TO3eH5yKEVHsmPx3zHJTNjVVxkUGfPOLFbQ0m7hGLDmzNW6555G3hnH5n_ESPxddlQspF8xPOlagzv5WMsCD2HjpfNSZONdZI3R8b5RlmMQJvYj6bAY',
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32.0 : 16.0,
            vertical: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Page Header
              const Text(
                'إضافة منتج جديد',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'أدخل التفاصيل الأساسية للمنسوجات الخاصة بك للبدء',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // Layout Grid
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Content (Left side in LTR, but in RTL layout it should be left or right)
                    Expanded(
                      flex: 3,
                      child: _buildFormContent(),
                    ),
                    const SizedBox(width: 32),
                    // Progress Stepper (Right side for RTL)
                    SizedBox(
                      width: 250,
                      child: _buildProgressStepper(),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHorizontalStepper(),
                    const SizedBox(height: 24),
                    _buildFormContent(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStepper() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          // Vertical Line
          Positioned(
            right: 19,
            top: 20,
            bottom: 20,
            child: Container(
              width: 2,
              color: AppColors.surfaceContainerHighest,
            ),
          ),
          // Steps Column
          Column(
            children: [
              _buildStepRow(1, 'المعلومات الأساسية', 'الاسم، الوصف، الفئة', true),
              const SizedBox(height: 28),
              _buildStepRow(2, 'المواصفات الفنية', 'الوزن، الكثافة، الغرز', false),
              const SizedBox(height: 28),
              _buildStepRow(3, 'التسعير والمخزون', 'الأسعار، الكميات المتاحة', false),
              const SizedBox(height: 28),
              _buildStepRow(4, 'الصور والملفات', 'رفع الوسائط والشهادات', false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(int number, String title, String subtitle, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? AppColors.onSurfaceVariant : AppColors.outline,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surfaceContainerHighest,
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            '$number',
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalStepper() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.looks_one, color: AppColors.primary),
          Icon(Icons.arrow_back_ios, size: 12, color: AppColors.outlineVariant),
          Icon(Icons.looks_two, color: AppColors.outlineVariant),
          Icon(Icons.arrow_back_ios, size: 12, color: AppColors.outlineVariant),
          Icon(Icons.looks_3, color: AppColors.outlineVariant),
          Icon(Icons.arrow_back_ios, size: 12, color: AppColors.outlineVariant),
          Icon(Icons.looks_4, color: AppColors.outlineVariant),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Section Title: Identity
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'هوية المنتج',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  ],
                ),
                const SizedBox(height: 20),

                // Product Name Field
                const Text(
                  'اسم المنتج',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    hintText: 'مثال: قطن مصري فاخر 100%',
                  ),
                ),
                const SizedBox(height: 20),

                // Category Selector Field
                const Text(
                  'الفئة',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  alignment: AlignmentDirectional.centerEnd,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.expand_more, color: AppColors.onSurfaceVariant),
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Short Description Textarea Field
                const Text(
                  'وصف مختصر',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  maxLength: 200,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  decoration: const InputDecoration(
                    hintText: 'أدخل وصفاً موجزاً للمنتج ومميزاته الرئيسية...',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_charCount / 200 حرف',
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 11, color: AppColors.outline),
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.outlineVariant, height: 1),
                const SizedBox(height: 24),

                // Section Title: Classification
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'نوع المنتج والاستخدام',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.category_outlined, color: AppColors.primary, size: 20),
                  ],
                ),
                const SizedBox(height: 20),

                // Product Nature Custom Radio
                const Text(
                  'طبيعة المنتج',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _productNature = 'صناعي';
                          });
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: _productNature == 'صناعي'
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _productNature == 'صناعي'
                                  ? AppColors.primary
                                  : AppColors.outlineVariant,
                              width: _productNature == 'صناعي' ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.factory_outlined,
                                color: _productNature == 'صناعي'
                                    ? AppColors.primary
                                    : AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'صناعي',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _productNature == 'صناعي'
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _productNature = 'تجزئة';
                          });
                        },
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: _productNature == 'تجزئة'
                                ? AppColors.primary.withValues(alpha: 0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _productNature == 'تجزئة'
                                  ? AppColors.primary
                                  : AppColors.outlineVariant,
                              width: _productNature == 'تجزئة' ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.storefront_outlined,
                                color: _productNature == 'تجزئة'
                                    ? AppColors.primary
                                    : AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'تجزئة',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: _productNature == 'تجزئة'
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Visibility Toggle Box
                const Text(
                  'حالة العرض',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Switch.adaptive(
                        value: _availableForDirectOrder,
                        activeThumbColor: AppColors.primary,
                        activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                        onChanged: (val) {
                          setState(() {
                            _availableForDirectOrder = val;
                          });
                        },
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'متاح للطلب المباشر',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'سيتمكن العملاء من الشراء فوراً',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Actions row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle submit
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        minimumSize: const Size(120, 48),
                      ),
                      icon: const Icon(Icons.arrow_back, size: 18),
                      label: const Text(
                        'التالي',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        minimumSize: const Size(120, 48),
                      ),
                      child: const Text(
                        'حفظ كمسودة',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Supplier Tip Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F6F3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFB2DFDB)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'نصيحة للموردين',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF004D40),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'استخدام أسماء وصفية دقيقة مثل "قطن جيزة 86 طويل التيلة" يساعد المصانع الذكية في العثور على منتجاتك بشكل أسرع في نتائج البحث المتقدمة.',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00796B),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.lightbulb_outline, color: Color(0xFF00796B)),
            ],
          ),
        ),
      ],
    );
  }
}
