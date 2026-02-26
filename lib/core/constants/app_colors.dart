import 'package:flutter/material.dart';

/// Centralized color palette for the TenderTrust app.
/// All pages should import from here instead of defining local constants.
class AppColors {
  AppColors._(); // prevent instantiation

  // ─── Brand Colors ───────────────────────────────────────────────────
  static const Color primary = Color(0xFFFF7E67);
  static const Color primaryLight = Color(0xFFFF9A85);
  static const Color secondary = Color(0xFF56C6A9);
  static const Color secondaryLight = Color(0xFF7AD4BD);

  // ─── Accent Colors ──────────────────────────────────────────────────
  static const Color accentYellow = Color(0xFFFFD166);
  static const Color accentBlue = Color(0xFF7F9CF5);
  static const Color accentPurple = Color(0xFFA78BFA);

  // ─── Surface Colors ─────────────────────────────────────────────────
  static const Color background = Color(0xFFFFF9F0);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFF1DB);

  // ─── Text Colors ────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2D3047);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFADB5BD);

  // ─── Border / Divider ───────────────────────────────────────────────
  static const Color border = Color(0xFFE8D5C4);
  static const Color divider = Color(0xFFEDE1D4);

  // ─── Status Colors ──────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ─── Booking Status ─────────────────────────────────────────────────
  static const Color statusPending = accentYellow;
  static const Color statusAccepted = secondary;
  static const Color statusOngoing = accentBlue;
  static const Color statusCompleted = success;
  static const Color statusEmergency = error;
  static const Color statusRejected = Color(0xFF9CA3AF);

  // ─── Gradients ──────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
