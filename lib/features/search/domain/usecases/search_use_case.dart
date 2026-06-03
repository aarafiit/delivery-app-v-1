import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../entities/search_results_entity.dart';
import '../repositories/search_repository.dart';

/// Input parameters for [SearchUseCase].
class SearchParams {
  final String query;
  final int limit;

  const SearchParams({required this.query, this.limit = 10});
}

class SearchUseCase extends BaseUseCase<SearchResults, SearchParams> {
  final SearchRepository _repository;

  const SearchUseCase(this._repository);

  @override
  Future<Either<Failure, SearchResults>> call(SearchParams params) =>
      _repository.search(params.query, limit: params.limit);
}
