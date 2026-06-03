import 'package:fpdart/fpdart.dart';

import '../../../../config/env/env_config.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/search_results_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

/// Concrete implementation of [SearchRepository].
/// Delegates to [SearchRemoteDataSource], rewrites localhost (MinIO) media
/// URLs to the configured host, and maps exceptions to typed [Failure] values.
class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;
  final EnvConfig _envConfig;

  const SearchRepositoryImpl(this._remoteDataSource, this._envConfig);

  /// Replaces any localhost/127.0.0.1 origin in a media URL with the
  /// configured [EnvConfig.mediaBaseUrl], so physical devices and emulators
  /// can reach MinIO or any local storage server.
  String _rewriteMediaUrl(String url) {
    if (url.isEmpty) return url;
    return url
        .replaceFirst(RegExp(r'http://localhost:\d+'), _envConfig.mediaBaseUrl)
        .replaceFirst(
            RegExp(r'http://127\.0\.0\.1:\d+'), _envConfig.mediaBaseUrl);
  }

  @override
  Future<Either<Failure, SearchResults>> search(String query,
      {int limit = 10}) async {
    try {
      final model = await _remoteDataSource.search(query, limit: limit);
      return Right(model.toEntity(_rewriteMediaUrl));
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }
}
