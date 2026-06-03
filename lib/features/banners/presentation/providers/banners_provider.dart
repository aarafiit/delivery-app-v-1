import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../../data/datasources/banner_remote_data_source.dart';
import '../../data/repositories/banner_repository_impl.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/banner_repository.dart';
import '../../domain/usecases/get_banners_use_case.dart';

// ── Infrastructure providers ────────────────────────────────────────────────

final bannerRemoteDataSourceProvider = Provider<BannerRemoteDataSource>((ref) {
  return BannerRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  return BannerRepositoryImpl(
    ref.watch(bannerRemoteDataSourceProvider),
    ref.watch(envConfigProvider),
  );
});

final getBannersUseCaseProvider = Provider<GetBannersUseCase>((ref) {
  return GetBannersUseCase(ref.watch(bannerRepositoryProvider));
});

// ── Banners list ────────────────────────────────────────────────────────────

/// Loads promotional banners from `GET /api/banners`.
class BannersNotifier extends AsyncNotifier<List<BannerEntity>> {
  @override
  Future<List<BannerEntity>> build() async {
    final useCase = ref.watch(getBannersUseCaseProvider);
    final result = await useCase(const NoParams());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (banners) => banners,
    );
  }
}

final bannersProvider =
    AsyncNotifierProvider<BannersNotifier, List<BannerEntity>>(
  BannersNotifier.new,
);
