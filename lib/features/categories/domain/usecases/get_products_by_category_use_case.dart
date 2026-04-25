import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../repositories/category_repository.dart';

class GetProductsByCategoryUseCase
    extends BaseUseCase<List<ProductEntity>, int> {
  final CategoryRepository _repository;

  const GetProductsByCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(int categoryId) =>
      _repository.getProductsByCategory(categoryId);
}
