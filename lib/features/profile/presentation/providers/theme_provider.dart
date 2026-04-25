import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global theme mode provider.
///
/// Defaults to [ThemeMode.light]. Toggle by writing to this provider:
/// ```dart
/// ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
/// ```
/// The app root reads this provider and passes it to [MaterialApp.themeMode].
/// (Requirements 19.1, 19.2, 19.3)
final themeModeProvider = StateProvider<ThemeMode>((_) => ThemeMode.light);
