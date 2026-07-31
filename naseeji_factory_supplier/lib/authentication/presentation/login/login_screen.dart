import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../shared/enums/user_role.dart';
import '../../../shared/validators/validators.dart';
import '../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneOrEmailController = TextEditingController(text: '01000000000');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  String _currentLanguage = 'العربية';

  @override
  void dispose() {
    _phoneOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusScope.of(context).unfocus();
    final success = await ref.read(authControllerProvider.notifier).login(
          _phoneOrEmailController.text.trim(),
          _passwordController.text,
          rememberMe: _rememberMe,
        );

    if (success && mounted) {
      final user = ref.read(authControllerProvider).user;
      _navigateByUserRole(user?.role);
    }
  }

  Future<void> _handleGoogleLogin() async {
    FocusScope.of(context).unfocus();
    final success = await ref.read(authControllerProvider.notifier).loginWithGoogle();
    if (success && mounted) {
      final user = ref.read(authControllerProvider).user;
      _navigateByUserRole(user?.role);
    }
  }

  Future<void> _handleDemoLogin(UserRole role) async {
    FocusScope.of(context).unfocus();
    await ref.read(authControllerProvider.notifier).loginDemo(role);
    if (mounted) {
      _navigateByUserRole(role);
    }
  }

  void _navigateByUserRole(UserRole? role) {
    if (role == UserRole.factory) {
      context.go('/factory/home');
    } else if (role == UserRole.supplier) {
      context.go('/supplier/dashboard');
    } else {
      context.go('/auth/choose-account-type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: isDark ? colorScheme.surface : const Color(0xFFFAFCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: AbsorbPointer(
            absorbing: authState.isLoading,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Language Dropdown Bar
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: _LanguageDropdownBadge(
                    currentLanguage: _currentLanguage,
                    onLanguageChanged: (lang) {
                      setState(() {
                        _currentLanguage = lang;
                      });
                    },
                  ),
                ),
                AppSpacing.hSM,

                // 2. Brand Identity & Illustration Header
                const _HeaderBrandSection(),

                AppSpacing.hMD,

                // 3. Welcome Title & Subtitle
                Text(
                  'تسجيل الدخول',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'مرحباً بعودتك! سجّل دخولك للوصول إلى حسابك',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),

                AppSpacing.hLG,

                // 4. Form Fields
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field 1: Email or Phone
                      const _FormInputLabel(label: 'البريد الإلكتروني أو رقم الهاتف'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneOrEmailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [
                          AutofillHints.email,
                          AutofillHints.telephoneNumber,
                          AutofillHints.username,
                        ],
                        textDirection: TextDirection.rtl,
                        style: theme.textTheme.bodyLarge,
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: 'أدخل بريدك الإلكتروني أو رقم هاتفك',
                          suffixIcon: Icons.person_outline_rounded,
                        ),
                        validator: Validators.emailOrPhone,
                      ),

                      AppSpacing.hMD,

                      // Field 2: Password
                      const _FormInputLabel(label: 'كلمة المرور'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        autofillHints: const [AutofillHints.password],
                        textDirection: TextDirection.rtl,
                        style: theme.textTheme.bodyLarge,
                        decoration: _buildInputDecoration(
                          context: context,
                          hintText: 'أدخل كلمة المرور',
                          suffixIcon: Icons.lock_outline_rounded,
                          prefixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: colorScheme.outline,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: Validators.password,
                      ),

                      const SizedBox(height: 8),

                      // Remember Me & Forgot Password Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember me (RTL Right side)
                          InkWell(
                            onTap: () {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                            borderRadius: AppRadius.rSM,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (val) {
                                        setState(() {
                                          _rememberMe = val ?? false;
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      activeColor: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'تذكرني',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Forgot password button (RTL Left side)
                          TextButton(
                            onPressed: () => context.push('/auth/forgot-password'),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                if (authState.errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer.withValues(alpha: 0.3),
                      borderRadius: AppRadius.rSM,
                    ),
                    child: Text(
                      authState.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                AppSpacing.hLG,

                // 5. Primary Login Button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: authState.isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                AppSpacing.hLG,

                // 6. Divider "أو"
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: isDark ? colorScheme.outlineVariant : const Color(0xFFE2E8F0),
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'أو',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: isDark ? colorScheme.outlineVariant : const Color(0xFFE2E8F0),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                AppSpacing.hLG,

                // 7. Google Sign In Button (NO Apple Sign In as requested)
                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: authState.isLoading ? null : _handleGoogleLogin,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isDark ? colorScheme.surfaceContainer : Colors.white,
                      side: BorderSide(
                        color: isDark ? colorScheme.outline : const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _GoogleLogoPainterWidget(size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'تسجيل الدخول بجوجل',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                AppSpacing.hXL,

                // 8. Account Registration Options Card
                _AccountRegistrationSection(
                  onRegisterFactory: () {
                    context.push('/auth/register', extra: UserRole.factory);
                  },
                  onRegisterSupplier: () {
                    context.push('/auth/register', extra: UserRole.supplier);
                  },
                ),

                AppSpacing.hLG,

                // 9. Bottom Demo Banner
                _DemoExploreBanner(
                  onDemoFactory: () => _handleDemoLogin(UserRole.factory),
                  onDemoSupplier: () => _handleDemoLogin(UserRole.supplier),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String hintText,
    IconData? suffixIcon,
    Widget? prefixIcon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      hintText: hintText,
      hintStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isDark ? colorScheme.onSurfaceVariant.withValues(alpha: 0.6) : const Color(0xFF94A3B8),
        fontSize: 13,
      ),
      filled: true,
      fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: suffixIcon != null
          ? Icon(
              suffixIcon,
              color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
              size: 20,
            )
          : null,
      prefixIcon: prefixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? colorScheme.outline.withValues(alpha: 0.4) : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.error,
          width: 1.5,
        ),
      ),
    );
  }
}

class _FormInputLabel extends StatelessWidget {
  final String label;

  const _FormInputLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Text(
      label,
      style: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: isDark ? theme.colorScheme.onSurface : const Color(0xFF1E293B),
        fontSize: 13.5,
      ),
    );
  }
}

// Language Switcher Badge
class _LanguageDropdownBadge extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const _LanguageDropdownBadge({
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return PopupMenuButton<String>(
      onSelected: onLanguageChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'العربية', child: Text('العربية')),
        PopupMenuItem(value: 'English', child: Text('English')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? colorScheme.outline : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              size: 16,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 6),
            Text(
              currentLanguage,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// Brand Logo & Factory Illustration Banner Header
class _HeaderBrandSection extends StatelessWidget {
  const _HeaderBrandSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side (RTL right): Logo & Titles
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _NaseejiInfinityLogo(size: 42),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NASEEJI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'نســيــجــي',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'منصة النسيج الرقمي للمصانع والموردين',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? theme.colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),

          // Right side (RTL left): Industrial Factory Backdrop Painting
          Expanded(
            flex: 5,
            child: Container(
              height: 110,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          theme.colorScheme.surface,
                          theme.colorScheme.primary.withValues(alpha: 0.15),
                        ]
                      : [
                          const Color(0xFFFAFCFF),
                          AppColors.primary.withValues(alpha: 0.08),
                        ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CustomPaint(
                  painter: _FactoryIllustrationPainter(isDark: isDark),
                  child: Container(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Double Mesh Infinity Blue NASEEJI Logo
class _NaseejiInfinityLogo extends StatelessWidget {
  final double size;

  const _NaseejiInfinityLogo({this.size = 40});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _InfinityLogoPainter(),
      ),
    );
  }
}

class _InfinityLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rect = Rect.fromLTWH(0, 0, w, h);

    final paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    final path1 = Path();
    path1.moveTo(w * 0.2, h * 0.5);
    path1.cubicTo(w * 0.05, h * 0.1, w * 0.5, h * 0.1, w * 0.5, h * 0.5);
    path1.cubicTo(w * 0.5, h * 0.9, w * 0.95, h * 0.9, w * 0.8, h * 0.5);
    canvas.drawPath(path1, paintStroke);

    // Inner Loop Accent
    final paintAccent = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.16
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(
        colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      ).createShader(rect);

    final path2 = Path();
    path2.moveTo(w * 0.8, h * 0.5);
    path2.cubicTo(w * 0.95, h * 0.1, w * 0.5, h * 0.1, w * 0.5, h * 0.5);
    path2.cubicTo(w * 0.5, h * 0.9, w * 0.05, h * 0.9, w * 0.2, h * 0.5);
    canvas.drawPath(path2, paintAccent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Factory Illustration Custom Painter
class _FactoryIllustrationPainter extends CustomPainter {
  final bool isDark;

  _FactoryIllustrationPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final buildingPaint = Paint()
      ..color = isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)
      ..style = PaintingStyle.fill;

    final roofPaint = Paint()
      ..color = isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)
      ..style = PaintingStyle.fill;

    final accentPaint = Paint()
      ..color = isDark ? const Color(0xFF3B82F6) : const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;

    // Factory main building body
    final buildingRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.35, h * 0.3, w * 0.55, h * 0.6),
      const Radius.circular(6),
    );
    canvas.drawRRect(buildingRect, buildingPaint);

    // Factory Sawtooth Roof
    final pathRoof = Path();
    pathRoof.moveTo(w * 0.35, h * 0.3);
    pathRoof.lineTo(w * 0.45, h * 0.15);
    pathRoof.lineTo(w * 0.45, h * 0.3);
    pathRoof.lineTo(w * 0.55, h * 0.15);
    pathRoof.lineTo(w * 0.55, h * 0.3);
    pathRoof.lineTo(w * 0.65, h * 0.15);
    pathRoof.lineTo(w * 0.65, h * 0.3);
    pathRoof.close();
    canvas.drawPath(pathRoof, roofPaint);

    // Factory Silos Chimneys
    canvas.drawRect(Rect.fromLTWH(w * 0.72, h * 0.15, w * 0.05, h * 0.3), roofPaint);
    canvas.drawRect(Rect.fromLTWH(w * 0.8, h * 0.1, w * 0.05, h * 0.35), roofPaint);

    // Truck / Transport Vehicle Outline
    final truckRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.55, w * 0.3, h * 0.35),
      const Radius.circular(4),
    );
    canvas.drawRRect(truckRect, accentPaint);

    // Truck Wheels
    final wheelPaint = Paint()..color = isDark ? Colors.black : const Color(0xFF1E293B);
    canvas.drawCircle(Offset(w * 0.18, h * 0.9), h * 0.08, wheelPaint);
    canvas.drawCircle(Offset(w * 0.32, h * 0.9), h * 0.08, wheelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Google Multi-color Logo Custom Painter
class _GoogleLogoPainterWidget extends StatelessWidget {
  final double size;

  const _GoogleLogoPainterWidget({this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    final paintRed = Paint()..color = const Color(0xFFEA4335);
    final paintBlue = Paint()..color = const Color(0xFF4285F4);
    final paintYellow = Paint()..color = const Color(0xFFFBBC05);
    final paintGreen = Paint()..color = const Color(0xFF34A853);

    // Draw Google 4 Color Arcs
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.5,
      1.5,
      true,
      paintRed,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      1.0,
      1.2,
      true,
      paintYellow,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.2,
      1.2,
      true,
      paintGreen,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.4,
      1.5,
      true,
      paintBlue,
    );

    // Inner White Hole
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.6, innerPaint);

    // Blue Bar in Center
    canvas.drawRect(
      Rect.fromLTWH(w * 0.45, h * 0.38, w * 0.5, h * 0.24),
      paintBlue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Account Registration Options Section (ليس لديك حساب؟)
class _AccountRegistrationSection extends StatelessWidget {
  final VoidCallback onRegisterFactory;
  final VoidCallback onRegisterSupplier;

  const _AccountRegistrationSection({
    required this.onRegisterFactory,
    required this.onRegisterSupplier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'ليس لديك حساب؟',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? colorScheme.onSurface : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'اختر نوع الحساب الذي يناسبك للانضمام إلى نسيجي',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Supplier Option Card (مورد)
              Expanded(
                child: _RoleCardItem(
                  title: 'مورد',
                  subtitle: 'أبيع منتجاتي وأستقبل طلبات المصانع وتفاوض على الأسعار',
                  buttonText: 'إنشاء حساب كمورد',
                  accentColor: const Color(0xFF2563EB),
                  icon: Icons.inventory_2_outlined,
                  onPressed: onRegisterSupplier,
                ),
              ),
              const SizedBox(width: 12),
              // Factory Option Card (مصنع)
              Expanded(
                child: _RoleCardItem(
                  title: 'مصنع',
                  subtitle: 'أشتري الخامات والمنتجات وأرسل طلبات الشراء',
                  buttonText: 'إنشاء حساب كمصنع',
                  accentColor: const Color(0xFF10B981),
                  icon: Icons.factory_outlined,
                  onPressed: onRegisterFactory,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleCardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color accentColor;
  final IconData icon;
  final VoidCallback onPressed;

  const _RoleCardItem({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.accentColor,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.5,
              color: isDark ? theme.colorScheme.onSurfaceVariant : const Color(0xFF64748B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 34,
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentColor, width: 1),
                foregroundColor: accentColor,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Bottom Demo Experience Banner (استكشف المنصة كتجربة دون تسجيل)
class _DemoExploreBanner extends StatelessWidget {
  final VoidCallback onDemoFactory;
  final VoidCallback onDemoSupplier;

  const _DemoExploreBanner({
    required this.onDemoFactory,
    required this.onDemoSupplier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? colorScheme.outline.withValues(alpha: 0.3) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_balance_outlined,
            size: 20,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'استكشف المنصة كتجربة دون تسجيل',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
                fontSize: 11.5,
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (val) {
              if (val == 'factory') onDemoFactory();
              if (val == 'supplier') onDemoSupplier();
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'factory',
                child: Text('تجربة المنصة كمصنع'),
              ),
              PopupMenuItem(
                value: 'supplier',
                child: Text('تجربة المنصة كمورد'),
              ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'تجربة المنصة كمصنع',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                  ),
                ),
                Icon(
                  Icons.chevron_left_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
