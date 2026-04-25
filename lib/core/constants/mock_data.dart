/// Static mock data used by the Products tab UI.
/// No API calls are made — all data is defined here as compile-time constants.
/// (Requirements 15.5)
class MockData {
  MockData._();

  /// Banner image URLs (using placeholder images).
  static const List<String> bannerImages = [
    'https://picsum.photos/seed/banner1/800/300',
    'https://picsum.photos/seed/banner2/800/300',
    'https://picsum.photos/seed/banner3/800/300',
  ];

  /// Category list — each entry has a [name] and an [icon] (IconData codePoint).
  static const List<Map<String, dynamic>> categories = [
    {'name': 'Food', 'icon': 0xe25a},       // Icons.fastfood
    {'name': 'Grocery', 'icon': 0xe556},    // Icons.shopping_cart
    {'name': 'Pharmacy', 'icon': 0xe549},   // Icons.local_pharmacy
    {'name': 'Drinks', 'icon': 0xe1bc},     // Icons.local_drink
    {'name': 'Bakery', 'icon': 0xe046},     // Icons.cake
    {'name': 'Snacks', 'icon': 0xf04c4},    // Icons.cookie
  ];

  /// Product list — each entry has [name], [price] (double), [image] URL, and [category].
  static const List<Map<String, dynamic>> products = [
    {
      'name': 'Chicken Burger',
      'price': 120.0,
      'image': 'https://picsum.photos/seed/prod1/200/200',
      'category': 'Food',
    },
    {
      'name': 'Fresh Milk 1L',
      'price': 85.0,
      'image': 'https://picsum.photos/seed/prod2/200/200',
      'category': 'Grocery',
    },
    {
      'name': 'Paracetamol 500mg',
      'price': 30.0,
      'image': 'https://picsum.photos/seed/prod3/200/200',
      'category': 'Pharmacy',
    },
    {
      'name': 'Orange Juice 500ml',
      'price': 65.0,
      'image': 'https://picsum.photos/seed/prod4/200/200',
      'category': 'Drinks',
    },
    {
      'name': 'Chocolate Cake',
      'price': 350.0,
      'image': 'https://picsum.photos/seed/prod5/200/200',
      'category': 'Bakery',
    },
    {
      'name': 'Potato Chips',
      'price': 45.0,
      'image': 'https://picsum.photos/seed/prod6/200/200',
      'category': 'Snacks',
    },
    {
      'name': 'Veggie Pizza',
      'price': 280.0,
      'image': 'https://picsum.photos/seed/prod7/200/200',
      'category': 'Food',
    },
    {
      'name': 'Basmati Rice 1kg',
      'price': 110.0,
      'image': 'https://picsum.photos/seed/prod8/200/200',
      'category': 'Grocery',
    },
  ];
}
