import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global locale provider.
///
/// Defaults to English. Toggle by writing to this provider:
/// ```dart
/// ref.read(localeProvider.notifier).state = const Locale('bn');
/// ```
/// The app root reads this provider and passes it to [MaterialApp.locale].
/// (Requirements 20.1, 20.2, 20.3)
final localeProvider = StateProvider<Locale>((_) => const Locale('en'));
