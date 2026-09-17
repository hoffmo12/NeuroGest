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
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
      ),

      // ── Localização PT-BR (necessário para o seletor de data) ──
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],

      home: const LoginScreen(),
    );
  }
}
