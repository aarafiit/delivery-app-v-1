import 'package:fpdart/fpdart.dart';

import '../../../../config/env/env_config.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/banner_entity.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_remote_data_source.dart';

/// Concrete implementation of [BannerRepository].
/// Delegates to [BannerRemoteDataSource], rewrites localhost (MinIO) media
/// URLs to the configured host, keeps only banners active today, and maps
/// exceptions to typed [Failure] values.
class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource _remoteDataSource;
  final EnvConfig _envConfig;

  const BannerRepositoryImpl(this._remoteDataSource, this._envConfig);

  /// Replaces any localhost/127.0.0.1 origin in a media URL with the
  /// configured [EnvConfig.mediaBaseUrl], so physical devices and emulators
  /// can reach MinIO or any local storage server.
  String _rewriteMediaUrl(String url) => url
      .replaceFirst(RegExp(r'http://localhost:\d+'), _envConfig.mediaBaseUrl)
      .replaceFirst(
          RegExp(r'http://127\.0\.0\.1:\d+'), _envConfig.mediaBaseUrl);

  @override
  Future<Either<Failure, List<BannerEntity>>> getBanners() async {
    try {
      final models = await _remoteDataSource.getBanners();
      final now = DateTime.now();
      final entities = models
          .map((m) => m.toEntity())
          .map((e) => BannerEntity(
                id: e.id,
                imageUrl: _rewriteMediaUrl(e.imageUrl),
                promotionTitle: e.promotionTitle,
                promotionDetails: e.promotionDetails,
                fromDate: e.fromDate,
                toDate: e.toDate,
              ))
          .where((e) => e.imageUrl.isNotEmpty && e.isActiveOn(now))
          .toList();
      return Right(entities);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }
}
