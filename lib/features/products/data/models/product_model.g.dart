// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: (json['id'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      discountPrice: (json['discountPrice'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      isAvailable: json['isAvailable'] as bool,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
    };
