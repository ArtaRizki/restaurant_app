// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantSearchModelImpl _$$RestaurantSearchModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RestaurantSearchModelImpl(
      error: json['error'] as bool,
      founded: json['founded'] as int,
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RestaurantSearchModelImplToJson(
        _$RestaurantSearchModelImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'founded': instance.founded,
      'restaurants': instance.restaurants,
    };

_$RestaurantImpl _$$RestaurantImplFromJson(Map<String, dynamic> json) =>
    _$RestaurantImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      pictureId: json['pictureId'] as String,
      city: json['city'] as String,
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$$RestaurantImplToJson(_$RestaurantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'pictureId': instance.pictureId,
      'city': instance.city,
      'rating': instance.rating,
    };
