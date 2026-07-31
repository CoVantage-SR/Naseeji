// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../domain/entities/supplier_profile.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/edit_profile_completion_card.dart';
import 'widgets/edit_profile_live_preview_card.dart';
import 'widgets/edit_profile_logo_cover_section.dart';
import 'widgets/edit_profile_basic_info_section.dart';
import 'widgets/edit_profile_categories_section.dart';
import 'widgets/edit_profile_contact_section.dart';
import 'widgets/edit_profile_address_section.dart';
import 'widgets/edit_profile_business_info_section.dart';
import 'widgets/edit_profile_social_links_section.dart';

class EditSupplierProfileScreen extends ConsumerStatefulWidget {
  const EditSupplierProfileScreen({super.key});

  @override
  ConsumerState<EditSupplierProfileScreen> createState() => _EditSupplierProfileScreenState();
}

class _EditSupplierProfileScreenState extends ConsumerState<EditSupplierProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  late TextEditingController _nameController;
  late TextEditingController _tradeNameController;
  late TextEditingController _businessTypeController;
  late TextEditingController _descriptionController;
  late TextEditingController _establishedYearController;
  late TextEditingController _employeesController;
  late TextEditingController _monthlyCapacityController;
  late TextEditingController _warehouseCapacityController;

  late TextEditingController _contactPersonController;
  late TextEditingController _phoneController;
  late TextEditingController _whatsappController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _businessHoursController;

  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _addressController;
  late TextEditingController _postalCodeController;

  late TextEditingController _crController;
  late TextEditingController _taxController;
  late TextEditingController _licenseController;
  late TextEditingController _experienceController;
  late TextEditingController _moqController;
  late TextEditingController _prodTimeController;

  late TextEditingController _fbController;
  late TextEditingController _instaController;
  late TextEditingController _linkedinController;
  late TextEditingController _xController;
  late TextEditingController _youtubeController;

  List<String> _selectedCategories = [];

  // Upload/Mock Image states
  String _currentLogoUrl = '';
  String _currentCoverUrl = '';
  double _logoUploadProgress = 0.0;
  double _coverUploadProgress = 0.0;
  bool _isUploadingLogo = false;
  bool _isUploadingCover = false;

  // Initial state tracking to verify unsaved changes
  late SupplierProfile _initialProfile;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  void _initializeFields(SupplierProfile profile) {
    _initialProfile = profile;
    _nameController = TextEditingController(text: profile.companyName);
    _tradeNameController = TextEditingController(text: profile.tradeName);
    _businessTypeController = TextEditingController(text: profile.businessType);
    _descriptionController = TextEditingController(text: profile.description);
    _establishedYearController = TextEditingController(text: profile.establishedYear);
    _employeesController = TextEditingController(text: profile.employeesCount.toString());
    _monthlyCapacityController = TextEditingController(text: profile.monthlyCapacity);
    _warehouseCapacityController = TextEditingController(text: profile.warehouseCapacity);

    _contactPersonController = TextEditingController(text: profile.contactPerson);
    _phoneController = TextEditingController(text: profile.phone);
    _whatsappController = TextEditingController(text: profile.whatsappNumber);
    _emailController = TextEditingController(text: profile.email);
    _websiteController = TextEditingController(text: profile.website);
    _businessHoursController = TextEditingController(text: profile.businessHours);

    _countryController = TextEditingController(text: profile.country);
    _cityController = TextEditingController(text: profile.city);
    _addressController = TextEditingController(text: profile.fullAddress);
    _postalCodeController = TextEditingController(text: profile.postalCode);

    _crController = TextEditingController(text: profile.commercialRegister);
    _taxController = TextEditingController(text: profile.taxRegistration);
    _licenseController = TextEditingController(text: profile.businessLicense);
    _experienceController = TextEditingController(text: profile.yearsOfExperience.toString());
    _moqController = TextEditingController(text: profile.moq.toString());
    _prodTimeController = TextEditingController(text: profile.averageProductionTime);

    _fbController = TextEditingController(text: profile.facebookUrl);
    _instaController = TextEditingController(text: profile.instagramUrl);
    _linkedinController = TextEditingController(text: profile.linkedinUrl);
    _xController = TextEditingController(text: profile.xUrl);
    _youtubeController = TextEditingController(text: profile.youtubeUrl);

    _selectedCategories = List.from(profile.categories);
    _currentLogoUrl = profile.logoUrl;
    _currentCoverUrl = profile.bannerUrl;

    _initialized = true;

    // Set listeners to trigger live update
    _nameController.addListener(() => setState(() {}));
    _cityController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
    _moqController.addListener(() => setState(() {}));
    _prodTimeController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tradeNameController.dispose();
    _businessTypeController.dispose();
    _descriptionController.dispose();
    _establishedYearController.dispose();
    _employeesController.dispose();
    _monthlyCapacityController.dispose();
    _warehouseCapacityController.dispose();
    _contactPersonController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _businessHoursController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _crController.dispose();
    _taxController.dispose();
    _licenseController.dispose();
    _experienceController.dispose();
    _moqController.dispose();
    _prodTimeController.dispose();
    _fbController.dispose();
    _instaController.dispose();
    _linkedinController.dispose();
    _xController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  bool _hasUnsavedChanges() {
    if (!_initialized) return false;
    return _nameController.text != _initialProfile.companyName ||
        _tradeNameController.text != _initialProfile.tradeName ||
        _businessTypeController.text != _initialProfile.businessType ||
        _descriptionController.text != _initialProfile.description ||
        _establishedYearController.text != _initialProfile.establishedYear ||
        _employeesController.text != _initialProfile.employeesCount.toString() ||
        _monthlyCapacityController.text != _initialProfile.monthlyCapacity ||
        _warehouseCapacityController.text != _initialProfile.warehouseCapacity ||
        _contactPersonController.text != _initialProfile.contactPerson ||
        _phoneController.text != _initialProfile.phone ||
        _whatsappController.text != _initialProfile.whatsappNumber ||
        _emailController.text != _initialProfile.email ||
        _websiteController.text != _initialProfile.website ||
        _businessHoursController.text != _initialProfile.businessHours ||
        _countryController.text != _initialProfile.country ||
        _cityController.text != _initialProfile.city ||
        _addressController.text != _initialProfile.fullAddress ||
        _postalCodeController.text != _initialProfile.postalCode ||
        _crController.text != _initialProfile.commercialRegister ||
        _taxController.text != _initialProfile.taxRegistration ||
        _licenseController.text != _initialProfile.businessLicense ||
        _experienceController.text != _initialProfile.yearsOfExperience.toString() ||
        _moqController.text != _initialProfile.moq.toString() ||
        _prodTimeController.text != _initialProfile.averageProductionTime ||
        _fbController.text != _initialProfile.facebookUrl ||
        _instaController.text != _initialProfile.instagramUrl ||
        _linkedinController.text != _initialProfile.linkedinUrl ||
        _xController.text != _initialProfile.xUrl ||
        _youtubeController.text != _initialProfile.youtubeUrl ||
        _currentLogoUrl != _initialProfile.logoUrl ||
        _currentCoverUrl != _initialProfile.bannerUrl ||
        _selectedCategories.length != _initialProfile.categories.length ||
        !_selectedCategories.every((cat) => _initialProfile.categories.contains(cat));
  }

  void _resetFields() {
    setState(() {
      _initializeFields(_initialProfile);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم استعادة البيانات الأصلية بنجاح.')),
    );
  }

  double _calculateCompletion() {
    double score = 0.0;
    if (_currentLogoUrl.isNotEmpty) score += 15.0;
    if (_currentCoverUrl.isNotEmpty) score += 15.0;
    if (_descriptionController.text.trim().isNotEmpty) score += 15.0;
    if (_addressController.text.trim().isNotEmpty) score += 15.0;
    if (_initialProfile.certificates.isNotEmpty) score += 20.0;
    if (_contactPersonController.text.trim().isNotEmpty && _phoneController.text.trim().isNotEmpty) score += 20.0;
    return score;
  }

  Future<bool> _showDiscardChangesDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('تراجع عن التعديلات؟', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        content: Text(
          'لديك تعديلات غير محفوظة على ملف الشركة. هل أنت متأكد من رغبتك في المغادرة وإلغاء هذه التعديلات؟',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('إكمال التعديل'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: Text('إلغاء التعديلات'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _simulateLogoUpload() async {
    setState(() {
      _isUploadingLogo = true;
      _logoUploadProgress = 0.0;
    });
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _logoUploadProgress = i * 0.2;
      });
    }
    setState(() {
      _isUploadingLogo = false;
      _currentLogoUrl = 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم رفع شعار الشركة المعتمد بنجاح.')),
    );
  }

  void _simulateCoverUpload() async {
    setState(() {
      _isUploadingCover = true;
      _coverUploadProgress = 0.0;
    });
    for (int i = 1; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _coverUploadProgress = i * 0.2;
      });
    }
    setState(() {
      _isUploadingCover = false;
      _currentCoverUrl = 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=600&q=80';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم رفع صورة الغلاف للمنشأة بنجاح.')),
    );
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى التحقق من صحة كافة الحقول المطلوبة.')),
      );
      return;
    }

    final updated = _initialProfile.copyWith(
      companyName: _nameController.text.trim(),
      tradeName: _tradeNameController.text.trim(),
      businessType: _businessTypeController.text.trim(),
      description: _descriptionController.text.trim(),
      establishedYear: _establishedYearController.text.trim(),
      employeesCount: int.tryParse(_employeesController.text.trim()) ?? 0,
      monthlyCapacity: _monthlyCapacityController.text.trim(),
      warehouseCapacity: _warehouseCapacityController.text.trim(),
      categories: _selectedCategories,
      contactPerson: _contactPersonController.text.trim(),
      phone: _phoneController.text.trim(),
      whatsappNumber: _whatsappController.text.trim(),
      email: _emailController.text.trim(),
      website: _websiteController.text.trim(),
      businessHours: _businessHoursController.text.trim(),
      country: _countryController.text.trim(),
      city: _cityController.text.trim(),
      fullAddress: _addressController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      commercialRegister: _crController.text.trim(),
      taxRegistration: _taxController.text.trim(),
      businessLicense: _licenseController.text.trim(),
      yearsOfExperience: int.tryParse(_experienceController.text.trim()) ?? 0,
      moq: int.tryParse(_moqController.text.trim()) ?? 0,
      averageProductionTime: _prodTimeController.text.trim(),
      facebookUrl: _fbController.text.trim(),
      instagramUrl: _instaController.text.trim(),
      linkedinUrl: _linkedinController.text.trim(),
      xUrl: _xController.text.trim(),
      youtubeUrl: _youtubeController.text.trim(),
      logoUrl: _currentLogoUrl,
      bannerUrl: _currentCoverUrl,
      completionRate: _calculateCompletion(),
    );

    // Save using repository and update controller
    await ref.read(profileControllerProvider.notifier).updateProfile(updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ وتحديث بيانات الشركة بنجاح وجاري إدراجها بالأنشطة.')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    return profileAsync.when(
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.primary))),
      error: (err, stack) => Scaffold(body: Center(child: Text('خطأ: $err'))),
      data: (profile) {
        if (!_initialized) {
          _initializeFields(profile);
        }

        final hasChanges = _hasUnsavedChanges();

        return PopScope(
          canPop: !hasChanges,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldLeave = await _showDiscardChangesDialog();
            if (shouldLeave && mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text('تعديل ملف الشركة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              centerTitle: true,
              leading: TextButton(
                onPressed: () async {
                  if (hasChanges) {
                    final shouldLeave = await _showDiscardChangesDialog();
                    if (shouldLeave && mounted) context.pop();
                  } else {
                    context.pop();
                  }
                },
                child: Text('تراجع', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              actions: [
                TextButton(
                  onPressed: _saveChanges,
                  child: Text('حفظ', style: TextStyle(color: Color(0xFF0040E0), fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Section 8: Profile Completion Rate
                    EditProfileCompletionCard(completionRate: _calculateCompletion()),
                    SizedBox(height: 16),

                    // Section 9: B2B Live Preview Card
                    EditProfileLivePreviewCard(
                      companyName: _nameController.text,
                      city: _cityController.text,
                      description: _descriptionController.text,
                      categories: _selectedCategories,
                      logoUrl: _currentLogoUrl,
                    ),
                    SizedBox(height: 20),

                    // Section 1: Logo & Cover Section
                    EditProfileLogoCoverSection(
                      currentLogoUrl: _currentLogoUrl,
                      currentCoverUrl: _currentCoverUrl,
                      isUploadingLogo: _isUploadingLogo,
                      isUploadingCover: _isUploadingCover,
                      logoUploadProgress: _logoUploadProgress,
                      coverUploadProgress: _coverUploadProgress,
                      onLogoUpload: _simulateLogoUpload,
                      onCoverUpload: _simulateCoverUpload,
                      onLogoRemove: () => setState(() => _currentLogoUrl = ''),
                      onCoverRemove: () => setState(() => _currentCoverUrl = ''),
                    ),
                    SizedBox(height: 16),

                    // Section 2: Basic Company Information
                    EditProfileBasicInfoSection(
                      nameController: _nameController,
                      tradeNameController: _tradeNameController,
                      businessTypeController: _businessTypeController,
                      descriptionController: _descriptionController,
                      establishedYearController: _establishedYearController,
                      employeesController: _employeesController,
                      monthlyCapacityController: _monthlyCapacityController,
                      warehouseCapacityController: _warehouseCapacityController,
                    ),
                    SizedBox(height: 16),

                    // Section 3: Supplier Categories
                    EditProfileCategoriesSection(
                      selectedCategories: _selectedCategories,
                      onCategoriesChanged: (newCategories) {
                        setState(() {
                          _selectedCategories = newCategories;
                        });
                      },
                    ),
                    SizedBox(height: 16),

                    // Section 4: Contact Information
                    EditProfileContactSection(
                      contactPersonController: _contactPersonController,
                      phoneController: _phoneController,
                      whatsappController: _whatsappController,
                      emailController: _emailController,
                      websiteController: _websiteController,
                      businessHoursController: _businessHoursController,
                    ),
                    SizedBox(height: 16),

                    // Section 5: Address & Map Preview
                    EditProfileAddressSection(
                      countryController: _countryController,
                      cityController: _cityController,
                      addressController: _addressController,
                      postalCodeController: _postalCodeController,
                      onCurrentLocationSelected: () {
                        setState(() {
                          _addressController.text = 'شارع الملك فهد، المنطقة الصناعية، الرياض، SA';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم الحصول على إحداثيات موقعك الحالي بنجاح.')),
                        );
                      },
                    ),
                    SizedBox(height: 16),

                    // Section 6: Business Info
                    EditProfileBusinessInfoSection(
                      crController: _crController,
                      taxController: _taxController,
                      licenseController: _licenseController,
                      experienceController: _experienceController,
                      moqController: _moqController,
                      prodTimeController: _prodTimeController,
                    ),
                    SizedBox(height: 16),

                    // Section 7: Social Links
                    EditProfileSocialLinksSection(
                      fbController: _fbController,
                      instaController: _instaController,
                      linkedinController: _linkedinController,
                      xController: _xController,
                      youtubeController: _youtubeController,
                    ),
                    SizedBox(height: 30),

                    // Bottom Action Bar Buttons
                    _buildBottomActionBar(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActionBar() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saveChanges,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0040E0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('حفظ كافة التعديلات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () async {
                  if (_hasUnsavedChanges()) {
                    final shouldLeave = await _showDiscardChangesDialog();
                    if (shouldLeave && mounted) context.pop();
                  } else {
                    context.pop();
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('إلغاء التعديلات والمغادرة', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _resetFields,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('إعادة ضبط الافتراضي', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}



