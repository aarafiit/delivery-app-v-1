import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/category_entity.dart';

abstract interface class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
