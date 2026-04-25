/// Domain entity representing a product category.
/// [iconKey] is a normalized string used by [CategoryIconMapper]
/// to resolve the display icon — kept in domain so the UI mapping
/// stays decoupled from the API field names.
class CategoryEntity {
  final int id;
  final String name;
  final bool isActive;
  final String iconKey;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.isActive,
    required this.iconKey,
  });
}
