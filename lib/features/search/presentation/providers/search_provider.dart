import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../data/datasources/search_remote_data_source.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/entities/search_results_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/search_use_case.dart';

// ── Infrastructure providers ────────────────────────────────────────────────

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(
    ref.watch(searchRemoteDataSourceProvider),
    ref.watch(envConfigProvider),
  );
});

final searchUseCaseProvider = Provider<SearchUseCase>((ref) {
  return SearchUseCase(ref.watch(searchRepositoryProvider));
});

// ── Search state ────────────────────────────────────────────────────────────

/// The current (debounced) search query. The UI updates this after a short
/// debounce so the API isn't hit on every keystroke.
final searchQueryProvider = StateProvider<String>((_) => '');

/// Resolves the search results for the active [searchQueryProvider].
///
/// Returns an empty result set without hitting the API when the query is
/// blank, so the screen can show its idle prompt instead of an error.
final searchResultsProvider = FutureProvider<SearchResults>((ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) return SearchResults.empty(query);

  final useCase = ref.watch(searchUseCaseProvider);
  final result = await useCase(SearchParams(query: query));
  return result.fold(
    (failure) => throw Exception(failure.message),
    (results) => results,
  );
});
