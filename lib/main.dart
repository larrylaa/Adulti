import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/theme.dart';
import 'app/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: AdultiApp()));
}

class AdultiApp extends StatelessWidget {
  const AdultiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adulti',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.auth,
      onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings),
      routes: AppRouter.routes,
    );
  }
}
