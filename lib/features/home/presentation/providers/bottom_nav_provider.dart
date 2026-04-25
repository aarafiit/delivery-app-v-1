import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks the currently selected bottom navigation tab index.
///
/// Valid values are 0–4 (Products, Categories, Search, Cart, Account).
/// Defaults to 0 (Products tab). (Requirements 14.5)
final bottomNavIndexProvider = StateProvider<int>((_) => 0);
