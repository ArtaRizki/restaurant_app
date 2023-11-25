// To parse this JSON data, do
//
//     final restaurantSearchModel = restaurantSearchModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'restaurant_search_model.freezed.dart';
part 'restaurant_search_model.g.dart';

RestaurantSearchModel restaurantSearchModelFromJson(String str) =>
    RestaurantSearchModel.fromJson(json.decode(str));

String restaurantSearchModelToJson(RestaurantSearchModel data) =>
    json.encode(data.toJson());

@freezed
class RestaurantSearchModel with _$RestaurantSearchModel {
  const factory RestaurantSearchModel({
    @JsonKey(name: "error") required bool error,
    @JsonKey(name: "founded") required int founded,
    @JsonKey(name: "restaurants") required List<Restaurant> restaurants,
  }) = _RestaurantSearchModel;

  factory RestaurantSearchModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantSearchModelFromJson(json);
}

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "pictureId") required String pictureId,
    @JsonKey(name: "city") required String city,
    @JsonKey(name: "rating") required double rating,
  }) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}
