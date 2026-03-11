import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_shell.dart';
import '../features/dashboard/dashboard_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    splash: (_) => const SplashScreen(),
    onboarding: (_) => const OnboardingShell(),
    dashboard: (_) => const DashboardScreen(),
  };
}
