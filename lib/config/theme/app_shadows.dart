import 'package:flutter/material.dart';

/// Centralized shadow/elevation styles for the app.
/// Use these instead of raw BoxShadow literals or elevation integers.
class AppShadows {
  AppShadows._();

  /// Subtle card lift — for list tiles, small cards
  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x0F000000), // ~6% black
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Section cards — for product cards, profile sections
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x1A000000), // ~10% black
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Floating elements — FABs, bottom sheets, modals
  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x24000000), // ~14% black
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
