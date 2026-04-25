import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase
    extends BaseUseCase<List<CategoryEntity>, NoParams> {
  final CategoryRepository _repository;

  const GetCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) =>
      _repository.getCategories();
}
