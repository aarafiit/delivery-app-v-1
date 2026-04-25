import 'package:fpdart/fpdart.dart';

import '../../../../config/env/env_config.dart';
import '../../../../core/error/api_exception.dart';
import '../../../../core/error/failure.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  final EnvConfig _envConfig;

  const CategoryRepositoryImpl(this._remoteDataSource, this._envConfig);

  String _rewriteMediaUrl(String url) => url
      .replaceFirst(RegExp(r'http://localhost:\d+'), _envConfig.mediaBaseUrl)
      .replaceFirst(
          RegExp(r'http://127\.0\.0\.1:\d+'), _envConfig.mediaBaseUrl);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final models = await _remoteDataSource.getCategories();
      return Right(models.where((m) => m.isActive).map((m) => m.toEntity()).toList());
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
      int categoryId) async {
    try {
      final models = await _remoteDataSource.getProductsByCategory(categoryId);
      final entities = models
          .where((m) => m.isAvailable)
          .map((m) {
            final e = m.toEntity();
            return ProductEntity(
              id: e.id,
              categoryId: e.categoryId,
              name: e.name,
              description: e.description,
              price: e.price,
              discountPrice: e.discountPrice,
              imageUrl: _rewriteMediaUrl(e.imageUrl),
              isAvailable: e.isAvailable,
            );
          })
          .toList();
      return Right(entities);
    } on ApiException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(NetworkFailure());
    }
  }
}
