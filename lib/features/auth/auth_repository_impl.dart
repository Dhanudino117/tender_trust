// ignore_for_file: unused_field

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../core/errors/failures.dart';
import '../../models/user_model.dart';
import 'auth_repository.dart';

/// Firebase implementation of [AuthRepository].
/// Handles all Firebase Auth + Firestore user profile operations.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    GoogleSignIn? googleSignIn,
  }) : _auth = auth,
       _firestore = firestore,
       _googleSignIn = googleSignIn ?? GoogleSignIn();

  // Cache the current user model to avoid repeated Firestore reads
  UserModel? _cachedUser;

  /// Reference to the users collection
  CollectionReference<Map<String, dynamic>> get _usersRef =>
      _firestore.collection('users');

  // ─── Auth State Stream ──────────────────────────────────────────────
  @override
  Stream<UserModel?> get authStateChanges {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        _cachedUser = null;
        return null;
      }
      // Try to fetch full profile from Firestore
      try {
        final doc = await _usersRef.doc(firebaseUser.uid).get();
        if (doc.exists) {
          _cachedUser = UserModel.fromFirestore(doc);
        } else {
          // Create a basic UserModel from Firebase Auth data
          _cachedUser = UserModel(
            id: firebaseUser.uid,
            name:
                firebaseUser.displayName ??
                firebaseUser.email?.split('@').first ??
                '',
            email: firebaseUser.email ?? '',
            phone: firebaseUser.phoneNumber,
            role: 'Parent',
          );
        }
        return _cachedUser;
      } catch (_) {
        // Fallback if Firestore is unreachable
        _cachedUser = UserModel(
          id: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          role: 'Parent',
        );
        return _cachedUser;
      }
    });
  }

  @override
  UserModel? get currentUser => _cachedUser;

  // ─── Email/Password Sign In ─────────────────────────────────────────
  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return await _getUserProfile(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebase(e.code, e.message);
    } catch (e) {
      throw AuthFailure('Sign in failed: $e');
    }
  }

  // ─── Google Sign In ─────────────────────────────────────────────────
  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthFailure(
          'Google sign-in was cancelled',
          code: 'cancelled',
        );
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Check if user profile exists, create if first time
      final doc = await _usersRef.doc(user.uid).get();
      if (!doc.exists) {
        final newUser = UserModel(
          id: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          role: 'Parent', // default role for Google sign-in
        );
        await saveUserProfile(newUser);
        _cachedUser = newUser;
        return newUser;
      }

      return await _getUserProfile(user);
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebase(e.code, e.message);
    } catch (e) {
      throw AuthFailure('Google sign-in failed: $e');
    }
  }

  // ─── Phone OTP ──────────────────────────────────────────────────────
  // Store the verification ID for later use
  String? _verificationId;

  @override
  Future<String> sendPhoneOtp(String phoneNumber) async {
    final completer = Completer<String>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        // Auto-verification on Android
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        completer.completeError(AuthFailure.fromFirebase(e.code, e.message));
      },
      codeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  @override
  Future<UserModel> verifyPhoneOtp(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Check if profile exists
      final doc = await _usersRef.doc(user.uid).get();
      if (!doc.exists) {
        final newUser = UserModel(
          id: user.uid,
          name: '',
          email: '',
          phone: user.phoneNumber,
          role: 'Parent',
        );
        await saveUserProfile(newUser);
        _cachedUser = newUser;
        return newUser;
      }

      return await _getUserProfile(user);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebase(e.code, e.message);
    } catch (e) {
      throw AuthFailure('OTP verification failed: $e');
    }
  }

  // ─── Sign Up ────────────────────────────────────────────────────────
  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user?.updateDisplayName(name);

      final newUser = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email.trim(),
        role: role,
      );

      // Save user profile to Firestore
      await saveUserProfile(newUser);
      _cachedUser = newUser;

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure.fromFirebase(e.code, e.message);
    } catch (e) {
      throw AuthFailure('Sign up failed: $e');
    }
  }

  // ─── Sign Out ───────────────────────────────────────────────────────
  @override
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
    _cachedUser = null;
  }

  // ─── User Role ──────────────────────────────────────────────────────
  @override
  Future<String> getUserRole() async {
    if (_cachedUser != null) return _cachedUser!.role;

    final user = _auth.currentUser;
    if (user == null) return 'Parent';

    try {
      final doc = await _usersRef.doc(user.uid).get();
      return doc.data()?['role'] as String? ?? 'Parent';
    } catch (_) {
      return 'Parent';
    }
  }

  // ─── FCM Token ──────────────────────────────────────────────────────
  @override
  Future<void> saveFcmToken(String token) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _usersRef.doc(user.uid).update({
      'fcmTokens': FieldValue.arrayUnion([token]),
    });
  }

  // ─── User Profile CRUD ─────────────────────────────────────────────
  @override
  Future<void> saveUserProfile(UserModel user) async {
    await _usersRef.doc(user.id).set(user.toMap(), SetOptions(merge: true));
  }

  /// Helper: Fetch or create user profile from Firestore
  Future<UserModel> _getUserProfile(User firebaseUser) async {
    final doc = await _usersRef.doc(firebaseUser.uid).get();
    if (doc.exists) {
      _cachedUser = UserModel.fromFirestore(doc);
      return _cachedUser!;
    }

    // First-time login (shouldn't happen for email/password, but safety net)
    final newUser = UserModel(
      id: firebaseUser.uid,
      name:
          firebaseUser.displayName ??
          firebaseUser.email?.split('@').first ??
          '',
      email: firebaseUser.email ?? '',
      role: 'Parent',
    );
    await saveUserProfile(newUser);
    _cachedUser = newUser;
    return newUser;
  }
}
