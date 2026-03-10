import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'features/auth/auth_providers.dart';
import 'pages/landing_page.dart';
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

  runApp(const ProviderScope(child: TenderTrustApp()));
}

class TenderTrustApp extends ConsumerWidget {
  const TenderTrustApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(appUserProvider);

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
      ),
      home: authState.when(
        data: (user) {
          if (user == null) return const TenderTrustLandingPage();
          return user.role == 'Caregiver'
              ? const CaregiverHome()
              : const ParentHome();
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFFFF7E67)),
          ),
        ),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
    );
  }
}
