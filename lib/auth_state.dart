import 'package:flutter/material.dart';

/// Simple in-memory auth state for TenderTrust.
/// No backend — just tracks login status and user info.
class AuthState extends ChangeNotifier {
  static final AuthState _instance = AuthState._();
  factory AuthState() => _instance;
  AuthState._();

  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  String _userRole = 'Parent'; // 'Parent' or 'Caregiver'

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userRole => _userRole;
  String get initials {
    if (_userName.isEmpty) return '?';
    final parts = _userName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }

  void login({
    required String name,
    required String email,
    required String role,
  }) {
    _userName = name;
    _userEmail = email;
    _userRole = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _userName = '';
    _userEmail = '';
    _userRole = 'Parent';
    _isLoggedIn = false;
    notifyListeners();
  }
}
