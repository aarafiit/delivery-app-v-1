import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Data-layer DTO for a product returned by the API.
/// Uses freezed for immutability and json_serializable for JSON mapping.
/// (Requirements 24.5)
@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required int id,
    required int categoryId,
    required String name,
    required String description,
    required double price,
    required double discountPrice,
    required String imageUrl,
    required bool isAvailable,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Maps this DTO to the domain [ProductEntity].
  ProductEntity toEntity() => ProductEntity(
        id: id,
        categoryId: categoryId,
        name: name,
        description: description,
        price: price,
        discountPrice: discountPrice,
        imageUrl: imageUrl,
        isAvailable: isAvailable,
      );
}
