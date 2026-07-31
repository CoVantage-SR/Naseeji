import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/register/register_form_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: const SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: RegisterFormWidget(),
          ),
        ),
      ),
    );
  }
}
