import '../../../../core/network/api_client.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Talks to the server cart endpoints for authenticated users.
///
/// - [getCart]   → GET  /app/consumer/{consumerId}/cart       (whole cart)
/// - [addItem]   → POST /app/consumer/{consumerId}/cart       (single item)
/// - [mergeCart] → POST /app/consumer/{consumerId}/cart/merge (whole cart)
class CartRemoteDataSource {
  final ApiClient _apiClient;

  const CartRemoteDataSource(this._apiClient);

  /// Fetches the authenticated user's server cart.
  ///
  /// The server doesn't return the original/discount price, so [price] is set
  /// to the server `unitPrice` and `discountPrice` to 0 (no strikethrough).
  Future<List<CartItemEntity>> getCart(String consumerId) async {
    final response =
        await _apiClient.dio.get('/app/consumer/$consumerId/cart');
    final body = response.data;
    final data = body is Map<String, dynamic> ? body['data'] : null;
    final items = data is Map<String, dynamic> ? data['items'] : null;
    if (items is! List) return [];

    return items.whereType<Map<String, dynamic>>().map((j) {
      final productId = (j['productId'] as num?)?.toInt() ?? 0;
      return CartItemEntity(
        id: productId,
        productId: productId,
        name: j['productName'] as String? ?? '',
        imageUrl: j['imageUrl'] as String? ?? '',
        price: (j['unitPrice'] as num?)?.toDouble() ?? 0,
        discountPrice: 0,
        quantity: (j['quantity'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  /// Adds a single item to the authenticated user's server cart.
  /// [item.quantity] is the amount being added in this action.
  Future<void> addItem({
    required String consumerId,
    required CartItemEntity item,
  }) async {
    await _apiClient.dio.post(
      '/app/consumer/$consumerId/cart',
      data: _payload(item),
    );
  }

  /// Merges a guest's local cart into the server cart after sign-in.
  Future<void> mergeCart({
    required String consumerId,
    required List<CartItemEntity> items,
  }) async {
    await _apiClient.dio.post(
      '/app/consumer/$consumerId/cart/merge',
      data: items.map(_payload).toList(),
    );
  }

  Map<String, dynamic> _payload(CartItemEntity i) => {
        'productId': i.productId,
        'productName': i.name,
        'imageUrl': i.imageUrl,
        'unitPrice': i.effectivePrice,
        'quantity': i.quantity,
      };
}
