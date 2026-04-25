import 'package:flutter/material.dart';

/// Centralized color constants for the app.
/// All color values are defined here to ensure consistency across the UI.
/// Never use raw Color(...) literals in UI files — always reference this class.
class AppColors {
  AppColors._();

  // ── Brand / Primary ──────────────────────────────────────────────────────
  /// Warm orange — main CTAs, active nav, primary buttons
  static const Color primary = Color(0xFFFF6B35);

  /// Darker shade for pressed/hover states
  static const Color primaryDark = Color(0xFFE55A28);

  /// Lighter tint for backgrounds and highlights
  static const Color primaryLight = Color(0xFFFF8C5A);

  /// Very light tint — chip backgrounds, tag fills
  static const Color primaryContainer = Color(0xFFFFF0EB);

  // ── Secondary ─────────────────────────────────────────────────────────────
  /// Calm blue — info badges, secondary actions
  static const Color secondary = Color(0xFF2D9CDB);
  static const Color secondaryLight = Color(0xFFE8F4FD);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFFE8F8EF);

  static const Color warning = Color(0xFFF2994A);
  static const Color warningLight = Color(0xFFFEF3E8);

  static const Color error = Color(0xFFEB5757);
  static const Color errorLight = Color(0xFFFDECEC);

  // ── Backgrounds ───────────────────────────────────────────────────────────
  /// App scaffold background — very light grey
  static const Color background = Color(0xFFF8F9FA);

  /// Card / sheet surface — pure white
  static const Color surface = Color(0xFFFFFFFF);

  /// Subtle section fills, input backgrounds
  static const Color surfaceVariant = Color(0xFFF3F4F6);

  // ── Text ──────────────────────────────────────────────────────────────────
  /// Near-black for headings and primary content
  static const Color textPrimary = Color(0xFF1A1A2E);

  /// Mid-grey for subtitles and secondary content
  static const Color textSecondary = Color(0xFF6B7280);

  /// Light grey for placeholder / hint text
  static const Color textHint = Color(0xFF9CA3AF);

  /// White text on colored backgrounds (buttons, badges)
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Utility ───────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFE5E7EB);
  static const Color disabled = Color(0xFFD1D5DB);
  static const Color disabledText = Color(0xFF9CA3AF);

  // ── Bottom Nav ────────────────────────────────────────────────────────────
  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navSelected = Color(0xFFFF6B35);
  static const Color navUnselected = Color(0xFF9CA3AF);
}
