import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductDetailsUseCase
    extends BaseUseCase<ProductEntity, int> {
  final ProductRepository _repository;

  const GetProductDetailsUseCase(this._repository);

  @override
  Future<Either<Failure, ProductEntity>> call(int id) =>
      _repository.getProductById(id);
}
