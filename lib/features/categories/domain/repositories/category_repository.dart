import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../entities/category_entity.dart';

abstract interface class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(int categoryId);
}
