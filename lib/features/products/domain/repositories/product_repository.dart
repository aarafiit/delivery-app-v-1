import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';

/// Abstract contract for the product repository.
/// (Requirements 24.6)
abstract interface class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProductById(int id);
}
