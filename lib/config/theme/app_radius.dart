import 'package:flutter/material.dart';

/// Centralized border radius scale for the app.
/// Use these tokens for all rounded corners.
/// Never use raw Radius.circular(N) literals in UI files.
class AppRadius {
  AppRadius._();

  /// 8.0 — small radius (buttons, input fields, small chips)
  static const double sm = 8.0;

  /// 12.0 — medium radius (cards, list tiles)
  static const double md = 12.0;

  /// 16.0 — large radius (bottom sheets, modals, banners)
  static const double lg = 16.0;

  /// 20.0 — extra large radius (hero cards, featured sections)
  static const double xl = 20.0;

  /// 100.0 — fully rounded (pills, avatars, FABs)
  static const double full = 100.0;

  // Convenience BorderRadius objects
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));
}
