import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dummy user data used until real auth/profile API is wired.
class DummyUser {
  const DummyUser._();

  static const String name = 'Abdullah Al Rafi';
  static const String phone = '+880 1700-000000';
}

/// Exposes the dummy user name. Replace with a real AsyncNotifierProvider
/// once the profile API is integrated.
final dummyUserNameProvider = Provider<String>((_) => DummyUser.name);

/// Exposes the dummy user phone.
final dummyUserPhoneProvider = Provider<String>((_) => DummyUser.phone);
