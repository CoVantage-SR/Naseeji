import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'package:naseeji_supplier/features/auth/presentation/controllers/registration_controller.dart';

class CreateAccountForm extends ConsumerStatefulWidget {
  const CreateAccountForm({super.key});

  @override
  ConsumerState<CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends ConsumerState<CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _companyController = TextEditingController();
  final _managerController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus Nodes for auto-scroll and auto-focus on error
  final _companyFocusNode = FocusNode();
  final _managerFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _govFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  bool _acceptTerms = false;
  bool _obscurePassword = true;

  // Governorate and Cities Data
  final Map<String, List<String>> _governorateCities = {
    'القاهرة': ['القاهرة الجديدة', 'مصر الجديدة', 'المعادي', 'وسط البلد', 'حلوان'],
    'الجيزة': ['الدقي', 'المهندسين', 'الهرم', '6 أكتوبر', 'الشيخ زايد'],
    'الإسكندرية': ['سموحة', 'المنتزه', 'سيدي بشر', 'الرمل', 'وسط الإسكندرية'],
    'الدقهلية': ['المنصورة', 'ميت غمر', 'السنبلاوين', 'دكرنس', 'طلخا'],
  };

  String? _selectedGovernorate;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _companyController.addListener(_onFieldChanged);
    _managerController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _passwordController.addListener(_onFieldChanged);
    _confirmPasswordController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _companyController.dispose();
    _managerController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _companyFocusNode.dispose();
    _managerFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _govFocusNode.dispose();
    _cityFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // Security Helper: Check for SQL Injection
  bool _hasSqlInjection(String val) {
    final lower = val.toLowerCase();
    return lower.contains("' or") ||
        lower.contains('" or') ||
        lower.contains('select ') ||
        lower.contains('union ') ||
        lower.contains('insert ') ||
        lower.contains('drop ') ||
        lower.contains('--');
  }

  // Individual Field Validators
  String? _validateCompany(String? val) {
    if (val == null || val.trim().isEmpty) return 'من فضلك اكتب اسم الشركة.';
    final clean = val.trim();
    if (clean.length < 3) return 'يجب أن يكون اسم الشركة 3 أحرف على الأقل.';
    if (clean.length > 100) return 'لا يجب أن يتجاوز اسم الشركة 100 حرف.';
    // Check Emojis
    if (RegExp(r'[\u2600-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDF00-\uDFFF]|\uD83D[\uDC00-\uDE4F]|\uD83D[\uDE80-\uDEFF]|\uD83E[\uDD00-\uDDFF]').hasMatch(clean)) {
      return 'اسم الشركة لا يمكن أن يحتوي على رموز تعبيرية.';
    }
    if (_hasSqlInjection(clean)) return 'اسم الشركة يحتوي على إدخال غير صالح.';
    return null;
  }

  String? _validateManager(String? val) {
    if (val == null || val.trim().isEmpty) return 'اكتب اسم المسؤول.';
    final clean = val.trim();
    if (clean.length < 3) return 'يجب أن يكون اسم المسؤول 3 أحرف على الأقل.';
    if (!RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$').hasMatch(clean)) {
      return 'يجب أن يحتوي اسم المسؤول على حروف فقط.';
    }
    if (RegExp(r'[\u2600-\u27BF]|[\uE000-\uF8FF]|\uD83C[\uDF00-\uDFFF]|\uD83D[\uDC00-\uDE4F]|\uD83D[\uDE80-\uDEFF]|\uD83E[\uDD00-\uDDFF]').hasMatch(clean)) {
      return 'اسم المسؤول لا يمكن أن يحتوي على رموز تعبيرية.';
    }
    return null;
  }

  String? _validatePhone(String? val) {
    if (val == null || val.trim().isEmpty) return 'اكتب رقم موبايل مصري صحيح.';
    final clean = val.trim();
    if (clean.length != 11) return 'رقم الموبايل يجب أن يتكون من 11 رقماً.';
    if (!RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(clean)) {
      return 'اكتب رقم موبايل مصري صحيح.';
    }
    return null;
  }

  String? _validateEmail(String? val) {
    if (val == null || val.trim().isEmpty) return 'اكتب بريد إلكتروني صحيح.';
    final clean = val.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(clean)) {
      return 'اكتب بريد إلكتروني صحيح.';
    }
    return null;
  }

  String? _validatePassword(String? val) {
    if (val == null || val.isEmpty) return 'كلمة المرور مطلوبة.';
    if (val.length < 8) return 'كلمة المرور لازم تكون 8 أحرف على الأقل.';
    if (!val.contains(RegExp(r'[0-9]'))) return 'لازم تحتوي على رقم.';
    if (!val.contains(RegExp(r'[!@#\$&*~]'))) return 'لازم تحتوي على رمز.';
    if (!val.contains(RegExp(r'[A-Z]')) || !val.contains(RegExp(r'[a-z]'))) {
      return 'يجب أن تحتوي كلمة المرور على حروف كبيرة وصغيرة.';
    }
    return null;
  }

  String? _validateConfirmPassword(String? val) {
    if (val == null || val.isEmpty) return 'تأكيد كلمة المرور مطلوب.';
    if (val != _passwordController.text) return 'كلمتا المرور غير متطابقتين.';
    return null;
  }

  // Password Strength Estimator
  String _getPasswordStrength(String password) {
    if (password.isEmpty) return '';
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#\$&*~]'))) score++;

    if (score <= 2) return 'ضعيفة';
    if (score <= 4) return 'متوسطة';
    return 'قوية';
  }

  Color _getStrengthColor(String strength) {
    if (strength == 'ضعيفة') return Colors.red;
    if (strength == 'متوسطة') return Colors.orange;
    if (strength == 'قوية') return Colors.green;
    return Colors.transparent;
  }

  // Auto-focus and scroll to first invalid field
  void _focusFirstInvalid() {
    if (_validateCompany(_companyController.text) != null) {
      _companyFocusNode.requestFocus();
      return;
    }
    if (_validateManager(_managerController.text) != null) {
      _managerFocusNode.requestFocus();
      return;
    }
    if (_validatePhone(_phoneController.text) != null) {
      _phoneFocusNode.requestFocus();
      return;
    }
    if (_validateEmail(_emailController.text) != null) {
      _emailFocusNode.requestFocus();
      return;
    }
    if (_selectedGovernorate == null) {
      _govFocusNode.requestFocus();
      return;
    }
    if (_selectedCity == null) {
      _cityFocusNode.requestFocus();
      return;
    }
    if (_validatePassword(_passwordController.text) != null) {
      _passwordFocusNode.requestFocus();
      return;
    }
    if (_validateConfirmPassword(_confirmPasswordController.text) != null) {
      _confirmPasswordFocusNode.requestFocus();
      return;
    }
  }

  // Submit and Validation Logic
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      _focusFirstInvalid();
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لازم توافق على الشروط والأحكام.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();

    // Duplicate Validation Simulation
    if (phone == '01000000000') {
      _showDuplicatePhoneDialog();
      return;
    }
    if (email == 'duplicate@gmail.com') {
      _showDuplicateEmailDialog();
      return;
    }

    // Save Data to Riverpod Controller
    ref.read(registrationControllerProvider.notifier).updateBasicAccount(
          name: _managerController.text.trim(),
          email: email,
          phone: phone,
          password: _passwordController.text,
          governorate: _selectedGovernorate ?? '',
          city: _selectedCity ?? '',
        );

    ref.read(registrationControllerProvider.notifier).updateCompanyDetails(
          companyName: _companyController.text.trim(),
          commercialRegistry: '',
          taxNumber: '',
          categories: const [],
        );

    if (mounted) {
      context.push('/supplier-registration');
    }
  }

  // Duplicate Dialogs
  void _showDuplicatePhoneDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('رقم الموبايل مستخدم بالفعل', textAlign: TextAlign.right),
        content: const Text('رقم الموبايل الذي أدخلته مسجل به حساب بالفعل لدينا.', textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
            },
            child: const Text('تسجيل الدخول'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('استخدام رقم آخر'),
          ),
        ],
      ),
    );
  }

  void _showDuplicateEmailDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('البريد الإلكتروني مستخدم بالفعل', textAlign: TextAlign.right),
        content: const Text('البريد الإلكتروني الذي أدخلته مسجل به حساب بالفعل لدينا.', textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('استخدام بريد آخر'),
          ),
        ],
      ),
    );
  }



  // Clickable Terms Dialog
  void _showTermsDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, textAlign: TextAlign.right),
        content: Text(content, textAlign: TextAlign.right),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  // Determine if form input is complete to enable/disable button visual status
  bool get _isFormInputComplete {
    return _companyController.text.trim().isNotEmpty &&
        _managerController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _emailController.text.trim().isNotEmpty &&
        _selectedGovernorate != null &&
        _selectedCity != null &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _acceptTerms;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registrationControllerProvider);
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    final strength = _getPasswordStrength(_passwordController.text);
    final strengthColor = _getStrengthColor(strength);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Row 1: Company Name & Manager Name
          if (isMobile) ...[
            CustomTextField(
              controller: _companyController,
              focusNode: _companyFocusNode,
              labelText: 'اسم الشركة *',
              prefixIcon: Icons.business_outlined,
              validator: _validateCompany,
              enabled: !state.isLoading,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _managerController,
              focusNode: _managerFocusNode,
              labelText: 'اسم المسؤول *',
              prefixIcon: Icons.person_outline,
              validator: _validateManager,
              enabled: !state.isLoading,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _companyController,
                    focusNode: _companyFocusNode,
                    labelText: 'اسم الشركة *',
                    prefixIcon: Icons.business_outlined,
                    validator: _validateCompany,
                    enabled: !state.isLoading,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _managerController,
                    focusNode: _managerFocusNode,
                    labelText: 'اسم المسؤول *',
                    prefixIcon: Icons.person_outline,
                    validator: _validateManager,
                    enabled: !state.isLoading,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Row 2: Email & Phone
          if (isMobile) ...[
            CustomTextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              labelText: 'رقم الهاتف *',
              keyboardType: TextInputType.phone,
              prefixText: '+20 ',
              validator: _validatePhone,
              enabled: !state.isLoading,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              labelText: 'البريد الإلكتروني *',
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              enabled: !state.isLoading,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    labelText: 'رقم الهاتف *',
                    keyboardType: TextInputType.phone,
                    prefixText: '+20 ',
                    validator: _validatePhone,
                    enabled: !state.isLoading,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    labelText: 'البريد الإلكتروني *',
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    enabled: !state.isLoading,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Row 3: Governorate & City Dropdowns
          if (isMobile) ...[
            DropdownButtonFormField<String>(
              focusNode: _govFocusNode,
              value: _selectedGovernorate,
              decoration: InputDecoration(
                labelText: 'المحافظة *',
                prefixIcon: const Icon(Icons.map_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _governorateCities.keys.map((gov) => DropdownMenuItem(value: gov, child: Text(gov))).toList(),
              onChanged: state.isLoading
                  ? null
                  : (val) {
                      setState(() {
                        _selectedGovernorate = val;
                        _selectedCity = null;
                      });
                    },
              validator: (val) => val == null ? 'يرجى اختيار المحافظة' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              focusNode: _cityFocusNode,
              value: _selectedCity,
              decoration: InputDecoration(
                labelText: 'المدينة *',
                prefixIcon: const Icon(Icons.location_city_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: _selectedGovernorate == null
                  ? []
                  : _governorateCities[_selectedGovernorate]!.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
              onChanged: state.isLoading
                  ? null
                  : (val) {
                      setState(() {
                        _selectedCity = val;
                      });
                    },
              validator: (val) => val == null ? 'يرجى اختيار المدينة' : null,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    focusNode: _govFocusNode,
                    value: _selectedGovernorate,
                    decoration: InputDecoration(
                      labelText: 'المحافظة *',
                      prefixIcon: const Icon(Icons.map_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _governorateCities.keys.map((gov) => DropdownMenuItem(value: gov, child: Text(gov))).toList(),
                    onChanged: state.isLoading
                        ? null
                        : (val) {
                            setState(() {
                              _selectedGovernorate = val;
                              _selectedCity = null;
                            });
                          },
                    validator: (val) => val == null ? 'يرجى اختيار المحافظة' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    focusNode: _cityFocusNode,
                    value: _selectedCity,
                    decoration: InputDecoration(
                      labelText: 'المدينة *',
                      prefixIcon: const Icon(Icons.location_city_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _selectedGovernorate == null
                        ? []
                        : _governorateCities[_selectedGovernorate]!.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                    onChanged: state.isLoading
                        ? null
                        : (val) {
                            setState(() {
                              _selectedCity = val;
                            });
                          },
                    validator: (val) => val == null ? 'يرجى اختيار المدينة' : null,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Row 4: Password & Confirm Password
          if (isMobile) ...[
            CustomTextField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              labelText: 'كلمة المرور *',
              obscureText: _obscurePassword,
              enabled: !state.isLoading,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.colorScheme.outline,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _confirmPasswordController,
              focusNode: _confirmPasswordFocusNode,
              labelText: 'تأكيد كلمة المرور *',
              obscureText: _obscurePassword,
              enabled: !state.isLoading,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.colorScheme.outline,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: _validateConfirmPassword,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    labelText: 'كلمة المرور *',
                    obscureText: _obscurePassword,
                    enabled: !state.isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: theme.colorScheme.outline,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: _validatePassword,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    labelText: 'تأكيد كلمة المرور *',
                    obscureText: _obscurePassword,
                    enabled: !state.isLoading,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: theme.colorScheme.outline,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    validator: _validateConfirmPassword,
                  ),
                ),
              ],
            ),
          ],

          // Password Strength Indicator
          if (strength.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'قوة كلمة المرور: $strength',
                  style: TextStyle(fontSize: 11, color: strengthColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                ...List.generate(3, (index) {
                  bool fill = false;
                  if (strength == 'ضعيفة' && index == 0) fill = true;
                  if (strength == 'متوسطة' && index <= 1) fill = true;
                  if (strength == 'قوية') fill = true;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 24,
                    height: 4,
                    decoration: BoxDecoration(
                      color: fill ? strengthColor : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              ],
            ),
          ],
          const SizedBox(height: 16),

          // Terms Checkbox
          Row(
            children: [
              Checkbox(
                value: _acceptTerms,
                activeColor: theme.colorScheme.primary,
                onChanged: state.isLoading
                    ? null
                    : (val) {
                        setState(() {
                          _acceptTerms = val ?? false;
                        });
                      },
              ),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    text: 'أوافق على ',
                    style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant),
                    children: [
                      TextSpan(
                        text: 'الشروط والأحكام',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push('/terms');
                          },
                      ),
                      const TextSpan(text: ' و '),
                      TextSpan(
                        text: 'سياسة الخصوصية',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push('/privacy');
                          },
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Action Button
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: _isFormInputComplete ? 1.0 : 0.6,
            child: PrimaryButton(
              text: 'متابعة',
              onPressed: state.isLoading ? null : _submit,
              isLoading: state.isLoading,
              suffixIcon: Icons.arrow_forward_rounded,
            ),
          ),
        ],
      ),
    );
  }
}