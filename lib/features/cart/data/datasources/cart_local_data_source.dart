import 'dart:convert';

import '../../../../core/storage/preferences_service.dart';
import '../../domain/entities/cart_item_entity.dart';

/// Persists the cart locally (SharedPreferences) so a guest's cart survives
/// app restarts. The cart is the display source of truth on the device;
/// authenticated carts are additionally synced to the server.
class CartLocalDataSource {
  final PreferencesService _prefs;

  const CartLocalDataSource(this._prefs);

  static const _key = 'cart_items';

  /// Loads the persisted cart. Returns an empty list when nothing is stored
  /// or the stored value can't be parsed.
  List<CartItemEntity> load() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(_fromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<CartItemEntity> items) async {
    final raw = jsonEncode(items.map(_toJson).toList());
    await _prefs.setString(_key, raw);
  }

  Future<void> clear() async {
    await _prefs.remove(_key);
  }

  static Map<String, dynamic> _toJson(CartItemEntity i) => {
        'id': i.id,
        'productId': i.productId,
        'name': i.name,
        'imageUrl': i.imageUrl,
        'price': i.price,
        'discountPrice': i.discountPrice,
        'quantity': i.quantity,
      };

  static CartItemEntity _fromJson(Map<String, dynamic> j) => CartItemEntity(
        id: (j['id'] as num?)?.toInt() ?? (j['productId'] as num).toInt(),
        productId: (j['productId'] as num).toInt(),
        name: j['name'] as String? ?? '',
        imageUrl: j['imageUrl'] as String? ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0,
        discountPrice: (j['discountPrice'] as num?)?.toDouble() ?? 0,
        quantity: (j['quantity'] as num?)?.toInt() ?? 1,
      );
}
