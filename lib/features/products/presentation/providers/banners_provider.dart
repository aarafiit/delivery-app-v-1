import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';

/// Provides the list of banner image URLs from MinIO.
///
/// Reads the [mediaBaseUrl] from the active [EnvConfig] so the correct
/// host is used on emulator, physical device, and production.
final bannersProvider = Provider<List<String>>((ref) {
  final config = ref.watch(envConfigProvider);
  final base = config.mediaBaseUrl;

  // List your banner filenames from the MinIO 'banners' bucket here.
  // The bucket must have public read access.
  return [
    '$base/banners/banner-02.png',
    '$base/banners/banner-03.png',
    '$base/banners/banner-01.png',
  ];
});
