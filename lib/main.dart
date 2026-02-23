import 'package:flutter/material.dart';

import 'pages/welcome.dart';

void main() {
  runApp(const TenderTrustApp());
}

class TenderTrustApp extends StatelessWidget {
  const TenderTrustApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TenderTrust — Childcare You Can Trust',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFFF6B6B),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF4ECDC4),
          onSecondary: Color(0xFFFFFFFF),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF1A1A2E),
          error: Color(0xFFB00020),
          onError: Color(0xFFFFFFFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8E7),
      ),
      home: const WelcomePage(),
    );
  }
}
