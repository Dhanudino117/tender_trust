import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/firebase_providers.dart';
import '../../models/user_model.dart';
import 'auth_repository.dart';
import 'auth_repository_impl.dart';

/// ─── Auth Repository Provider ────────────────────────────────────────────
/// Provides the AuthRepository implementation to the widget tree.
/// Can be overridden in tests with a mock implementation.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

/// ─── Auth State Provider ─────────────────────────────────────────────────
/// Streams the current user's authentication state (UserModel or null).
/// Rebuilds automatically when the user logs in/out.
final appUserProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// ─── Current User Provider (synchronous access) ──────────────────────────
/// Returns the current UserModel if available, otherwise null.
/// Useful for quick checks without awaiting the stream.
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(appUserProvider).valueOrNull;
});

/// ─── Is Logged In Provider ───────────────────────────────────────────────
final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

/// ─── User Role Provider ──────────────────────────────────────────────────
final userRoleProvider = Provider<String>((ref) {
  return ref.watch(currentUserProvider)?.role ?? 'Parent';
});
