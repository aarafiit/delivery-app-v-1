import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_product_details_use_case.dart';
import '../../../auth/domain/usecases/base_use_case.dart';
import 'products_provider.dart';

/// Provider for [GetProductDetailsUseCase].
final getProductDetailsUseCaseProvider =
    Provider<GetProductDetailsUseCase>((ref) {
  return GetProductDetailsUseCase(ref.watch(productRepositoryProvider));
});

/// Family provider — fetches a single product by [id].
/// Each unique id gets its own cached AsyncValue.
final productDetailsProvider =
    AsyncNotifierProviderFamily<ProductDetailsNotifier, ProductEntity, int>(
  ProductDetailsNotifier.new,
);

class ProductDetailsNotifier
    extends FamilyAsyncNotifier<ProductEntity, int> {
  @override
  Future<ProductEntity> build(int arg) async {
    final useCase = ref.watch(getProductDetailsUseCaseProvider);
    final result = await useCase(arg);
    return result.fold(
      (failure) => throw Exception(failure.message),
      (product) => product,
    );
  }
}

/// Local quantity state for the product details screen.
/// Keyed by product id so each product has its own counter.
final productQuantityProvider =
    StateProviderFamily<int, int>((ref, productId) => 1);
