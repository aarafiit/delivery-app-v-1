import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository _repo;
  const GetCartUseCase(this._repo);
  Future<List<CartItemEntity>> call() => _repo.getCart();
}

class AddToCartUseCase {
  final CartRepository _repo;
  const AddToCartUseCase(this._repo);
  Future<void> call(int productId, int quantity) =>
      _repo.addToCart(productId, quantity);
}

class UpdateQuantityUseCase {
  final CartRepository _repo;
  const UpdateQuantityUseCase(this._repo);
  Future<void> call(int cartItemId, int quantity) =>
      _repo.updateQuantity(cartItemId, quantity);
}

class RemoveItemUseCase {
  final CartRepository _repo;
  const RemoveItemUseCase(this._repo);
  Future<void> call(int cartItemId) => _repo.removeItem(cartItemId);
}
