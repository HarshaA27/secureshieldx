import 'package:flutter/material.dart';
import 'core/theme/theme.dart';
import 'router/app_router.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    debugPrint('Firebase Core successfully initialized.');
  } catch (e) {
    debugPrint('Firebase Core initialization notice: $e');
  }
  runApp(const SecureShieldApp());
}

class SecureShieldApp extends StatefulWidget {
  const SecureShieldApp({super.key});

  @override
  State<SecureShieldApp> createState() => _SecureShieldAppState();
}

class _SecureShieldAppState extends State<SecureShieldApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = createRouter(
      onToggleTheme: _toggleTheme,
      currentThemeMode: _themeMode,
    );

    return MaterialApp.router(
      title: 'SecureShield X',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: router,
    );
  }
}
