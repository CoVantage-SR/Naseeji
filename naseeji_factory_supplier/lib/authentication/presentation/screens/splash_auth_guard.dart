import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';
import '../../data/models/user_model.dart';

class SplashAuthGuard extends ConsumerStatefulWidget {
  const SplashAuthGuard({super.key});

  @override
  ConsumerState<SplashAuthGuard> createState() => _SplashAuthGuardState();
}

class _SplashAuthGuardState extends ConsumerState<SplashAuthGuard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    switch (authState.status) {
      case AuthStatus.initial:
      case AuthStatus.loading:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );

      case AuthStatus.authenticated:
        final role = authState.user?.role;
        if (role == UserRole.factory) {
          return const _PlaceholderScreen(title: 'Factory Home Screen');
        } else if (role == UserRole.supplier) {
          return const _PlaceholderScreen(title: 'Supplier Home Screen');
        } else if (role == UserRole.admin) {
          return const _PlaceholderScreen(title: 'Admin Dashboard Screen');
        }
        return const _PlaceholderScreen(title: 'Home Screen');

      case AuthStatus.verificationPending:
        return const _PlaceholderScreen(
          title: 'Account Verification Pending. Our team is reviewing your documents.',
        );

      case AuthStatus.unauthenticated:
      case AuthStatus.error:
      default:
        return const _PlaceholderScreen(title: 'Login Screen');
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
