import 'package:flutter/material.dart';
import 'auth_state.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'pages/welcome.dart';
import 'pages/parent/parent_home.dart';
import 'pages/caregiver/caregiver_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization error: $e");
  }

  runApp(const TenderTrustApp());
}

class TenderTrustApp extends StatelessWidget {
  const TenderTrustApp({super.key});

  Widget get _homeScreen {
    final auth = AuthState();
    if (!auth.isLoggedIn) return const WelcomePage();
    return auth.userRole == 'Caregiver'
        ? const CaregiverHome()
        : const ParentHome();
  }

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
          primary: Color(0xFFFF7E67),
          onPrimary: Color(0xFFFFFFFF),
          secondary: Color(0xFF56C6A9),
          onSecondary: Color(0xFFFFFFFF),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF2D3047),
          error: Color(0xFFB00020),
          onError: Color(0xFFFFFFFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF9F0),
        scaffoldBackgroundColor: Color(0xFFFFF8E7),
      ),
      home: _homeScreen,
    );
  }
}