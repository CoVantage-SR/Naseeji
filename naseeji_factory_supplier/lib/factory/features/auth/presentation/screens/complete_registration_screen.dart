import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../providers/auth_provider.dart';
import '../widgets/complete_reg_widgets.dart';

class CompleteRegistrationScreen extends ConsumerStatefulWidget {
  const CompleteRegistrationScreen({super.key});

  @override
  ConsumerState<CompleteRegistrationScreen> createState() => _CompleteRegistrationScreenState();
}

class _CompleteRegistrationScreenState extends ConsumerState<CompleteRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState!.validate()) {
      ref.read(authProvider.notifier).completeGoogleRegistration(_phoneController.text.trim());
      // Auth notifier automatically signs the user in as authenticated, but isProfileCompleted: false,
      // which will trigger the listener in main or router to go to /factory-type
      context.go('/factory-type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إكمال البيانات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () {
            ref.read(authProvider.notifier).logout();
            context.go('/login');
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'خطوة واحدة متبقية!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (!isKeyboardOpen) ...[
                    AppSpacing.hXS,
                    Text(
                      'يرجى تأكيد رقم هاتفك المحمول لربطه بحساب Google الخاص بك.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                    AppSpacing.hXL,
                    const GoogleUserCardWidget(),
                  ],
                  AppSpacing.hLG,
                  PhoneNumberWidget(controller: _phoneController),
                  AppSpacing.hXL,
                  AppButton.primary(
                    text: 'تأكيد ومتابعة التسجيل',
                    onPressed: _onContinue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

