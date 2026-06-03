import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/search_results_entity.dart';

abstract interface class SearchRepository {
  Future<Either<Failure, SearchResults>> search(String query, {int limit});
}
