import 'package:fpdart/fpdart.dart';

import '../../../../config/env/env_config.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

/// Concrete implementation of [ProductRepository].
/// Delegates to [ProductRemoteDataSource], filters unavailable products,
/// rewrites localhost media URLs, and maps exceptions to typed [Failure] values.
/// (Requirements 24.3, 24.5)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final EnvConfig _envConfig;

  const ProductRepositoryImpl(this._remoteDataSource, this._envConfig);

  /// Replaces any localhost/127.0.0.1 origin in a media URL with the
  /// configured [EnvConfig.mediaBaseUrl], so physical devices and emulators
  /// can reach MinIO or any local storage server.
  String _rewriteMediaUrl(String url) {
    return url
        .replaceFirst(RegExp(r'http://localhost:\d+'), _envConfig.mediaBaseUrl)
        .replaceFirst(
            RegExp(r'http://127\.0\.0\.1:\d+'), _envConfig.mediaBaseUrl);
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final models = await _remoteDataSource.getProducts();
      final entities = models
          .where((m) => m.isAvailable)
          .map((m) => m.toEntity())
          .map((e) => ProductEntity(
                id: e.id,
                categoryId: e.categoryId,
                name: e.name,
                description: e.description,
                price: e.price,
                discountPrice: e.discountPrice,
                imageUrl: _rewriteMediaUrl(e.imageUrl),
                isAvailable: e.isAvailable,
              ))
          .toList();
      return Right(entities);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }
}
