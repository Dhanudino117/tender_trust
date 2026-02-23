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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const WelcomePage(),
    );
  }
}
