import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme.dart';
import 'app/router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: AdultinApp(),
    ),
  );
}

class AdultinApp extends StatelessWidget {
  const AdultinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adultin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
    );
  }
}
