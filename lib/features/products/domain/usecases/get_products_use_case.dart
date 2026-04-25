import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

/// Use case for fetching the full product list.
/// Delegates to [ProductRepository.getProducts].
/// (Requirements 24.6)
class GetProductsUseCase extends BaseUseCase<List<ProductEntity>, NoParams> {
  final ProductRepository _repository;

  const GetProductsUseCase(this._repository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params) =>
      _repository.getProducts();
}
