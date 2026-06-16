import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NeuroGestApp());
}

class NeuroGestApp extends StatelessWidget {
  const NeuroGestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeuroGest',
      // theme: ThemeData(useMaterial3: true, fontFamily: 'Arial'),
      themeMode: ThemeMode.dark,
      // darkTheme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}
