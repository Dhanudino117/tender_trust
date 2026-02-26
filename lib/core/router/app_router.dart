import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/firebase_providers.dart';
import '../../pages/welcome.dart';
import '../../pages/login_page.dart';
import '../../pages/profile_page.dart';
import '../../pages/parent/parent_home.dart';
import '../../pages/caregiver/caregiver_home.dart';
import '../../pages/landing_page.dart';

/// ─── Route Paths ─────────────────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();
  static const String welcome = '/';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String parentHome = '/parent';
  static const String caregiverHome = '/caregiver';
  static const String profile = '/profile';
}

/// ─── GoRouter Provider ───────────────────────────────────────────────────
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: true,

    // Global redirect — auth guard
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.welcome ||
          state.matchedLocation == AppRoutes.landing;

      // Not logged in and trying to access protected route
      if (!isLoggedIn && !isAuthRoute) {
        return AppRoutes.login;
      }

      return null; // no redirect
    },

    routes: [
      // ─── Public Routes ────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: AppRoutes.landing,
        builder: (context, state) => const TenderTrustLandingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      // ─── Protected Routes ─────────────────────────────────────────
      GoRoute(
        path: AppRoutes.parentHome,
        builder: (context, state) => const ParentHome(),
      ),
      GoRoute(
        path: AppRoutes.caregiverHome,
        builder: (context, state) => const CaregiverHome(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfilePage(),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3047),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go(AppRoutes.welcome),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
