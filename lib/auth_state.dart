import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Legacy singleton auth state — bridges to Riverpod providers.
///
/// Existing pages can continue to use `AuthState()` while we
/// incrementally migrate them to use Riverpod `ref.watch(...)`.
///
/// New code should use [authRepositoryProvider] and [appUserProvider]
/// from `features/auth/auth_providers.dart` instead.
class AuthState extends ChangeNotifier {
  static final AuthState _instance = AuthState._();
  factory AuthState() => _instance;

  AuthState._() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      _firebaseUser = user;
      _userDocSubscription?.cancel();

      if (user != null) {
        // Listen to Firestore for real-time profile updates (role, image, etc.)
        _userDocSubscription = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((doc) {
              if (doc.exists) {
                final data = doc.data()!;
                _userRole = data['role'] as String? ?? 'Parent';
                _profileImageUrl = data['profileImageUrl'] as String?;
              } else {
                _userRole = 'Parent';
                _profileImageUrl = null;
              }
              notifyListeners();
            });
      } else {
        _userRole = 'Parent';
        _profileImageUrl = null;
        notifyListeners();
      }
    });
  }

  User? _firebaseUser;
  StreamSubscription? _userDocSubscription;
  String _userRole = 'Parent';
  String? _profileImageUrl;

  bool get isLoggedIn => _firebaseUser != null;

  String get userId => _firebaseUser?.uid ?? '';

  String get userEmail => _firebaseUser?.email ?? '';

  String get userName =>
      _firebaseUser?.displayName ?? userEmail.split('@').first;

  String get userRole => _userRole;
  String? get profileImageUrl => _profileImageUrl;

  String get initials {
    final name = userName.trim();
    if (name.isEmpty) return '?';

    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      await credential.user?.updateDisplayName(name);

      // Save user profile to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'name': name,
            'email': email.trim(),
            'role': role,
            'isVerified': false,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

      _userRole = role;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Signup failed";
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
