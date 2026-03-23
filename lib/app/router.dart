import 'package:flutter/material.dart';
import '../features/auth/auth_gate.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_shell.dart';
import '../features/main_shell.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    auth: (_) => const AuthGate(),
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingShell(),
    dashboard: (_) => const MainShell(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == dashboard) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => const MainShell(),
      );
    }
    return null;
  }
}
