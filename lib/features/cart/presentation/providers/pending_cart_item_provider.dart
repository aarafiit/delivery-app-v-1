import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/domain/entities/product_entity.dart';

/// StateProvider that stores a product pending cart addition.
/// 
/// When a guest user attempts to add a product to cart, the product is stored
/// here temporarily. After successful authentication, the product is automatically
/// added to the cart and this state is cleared.
/// 
/// Requirements: 40.2
final pendingCartItemProvider = StateProvider<ProductEntity?>((ref) => null);
