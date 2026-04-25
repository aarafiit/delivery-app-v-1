import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../../../products/domain/entities/product_entity.dart';
import '../../data/datasources/category_remote_data_source.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/get_products_by_category_use_case.dart';

// ── Infrastructure providers ────────────────────────────────────────────────

final categoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    ref.watch(categoryRemoteDataSourceProvider),
    ref.watch(envConfigProvider),
  );
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  return GetCategoriesUseCase(ref.watch(categoryRepositoryProvider));
});

final getProductsByCategoryUseCaseProvider =
    Provider<GetProductsByCategoryUseCase>((ref) {
  return GetProductsByCategoryUseCase(ref.watch(categoryRepositoryProvider));
});

// ── Categories list ─────────────────────────────────────────────────────────

class CategoriesNotifier extends AsyncNotifier<List<CategoryEntity>> {
  @override
  Future<List<CategoryEntity>> build() async {
    final useCase = ref.watch(getCategoriesUseCaseProvider);
    final result = await useCase(const NoParams());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (categories) => categories,
    );
  }
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesNotifier, List<CategoryEntity>>(
  CategoriesNotifier.new,
);

// ── Selected category state ─────────────────────────────────────────────────

/// Holds the currently selected [CategoryEntity] on the Categories screen.
/// Null means "no selection yet" — the screen auto-selects the first category.
final selectedCategoryProvider =
    StateProvider<CategoryEntity?>((ref) => null);

// ── Products by category ────────────────────────────────────────────────────

/// Family provider — fetches products for a given [categoryId].
/// Each id gets its own cached AsyncValue; switching categories is instant
/// on revisit without re-fetching.
final productsByCategoryProvider =
    AsyncNotifierProviderFamily<ProductsByCategoryNotifier, List<ProductEntity>, int>(
  ProductsByCategoryNotifier.new,
);

class ProductsByCategoryNotifier
    extends FamilyAsyncNotifier<List<ProductEntity>, int> {
  @override
  Future<List<ProductEntity>> build(int arg) async {
    final useCase = ref.watch(getProductsByCategoryUseCaseProvider);
    final result = await useCase(arg);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (products) => products,
    );
  }
}
