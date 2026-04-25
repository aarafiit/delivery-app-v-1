import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client_provider.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_use_case.dart';

/// Provider for [ProductRemoteDataSource].
final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProductRemoteDataSourceImpl(apiClient);
});

/// Provider for [ProductRepository].
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final dataSource = ref.watch(productRemoteDataSourceProvider);
  final envConfig = ref.watch(envConfigProvider);
  return ProductRepositoryImpl(dataSource, envConfig);
});

/// Provider for [GetProductsUseCase].
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsUseCase(repository);
});

/// AsyncNotifier that fetches and exposes the product list.
/// Handles loading, data, and error states automatically via [AsyncValue].
/// (Requirements 24.7)
class ProductsNotifier extends AsyncNotifier<List<ProductEntity>> {
  @override
  Future<List<ProductEntity>> build() async {
    final useCase = ref.watch(getProductsUseCaseProvider);
    final result = await useCase(const NoParams());
    return result.fold(
      (failure) => throw Exception(failure.message),
      (products) => products,
    );
  }
}

/// The main provider consumed by the UI.
final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<ProductEntity>>(
  ProductsNotifier.new,
);
