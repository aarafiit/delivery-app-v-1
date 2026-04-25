import '../../domain/entities/category_entity.dart';
import '../../../../core/constants/category_icon_mapper.dart';

/// Data-layer DTO for a category returned by the API.
/// Manually parsed — no freezed needed for a simple two-field model.
class CategoryModel {
  final int id;
  final String name;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: (json['id'] as num).toInt(),
        name: json['name'] as String,
        isActive: json['isActive'] as bool,
      );

  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
        isActive: isActive,
        iconKey: CategoryIconMapper.keyFor(name),
      );
}
