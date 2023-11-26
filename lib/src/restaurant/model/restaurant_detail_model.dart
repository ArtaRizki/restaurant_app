// To parse this JSON data, do
//
//     final restaurantDetailModel = restaurantDetailModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'restaurant_detail_model.freezed.dart';
part 'restaurant_detail_model.g.dart';

RestaurantDetailModel restaurantDetailModelFromJson(String str) =>
    RestaurantDetailModel.fromJson(json.decode(str));

String restaurantDetailModelToJson(RestaurantDetailModel data) =>
    json.encode(data.toJson());

@freezed
class RestaurantDetailModel with _$RestaurantDetailModel {
  const factory RestaurantDetailModel({
    @JsonKey(name: "error") required bool error,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "restaurant") required Restaurant restaurant,
  }) = _RestaurantDetailModel;

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantDetailModelFromJson(json);
}

@freezed
class Restaurant with _$Restaurant {
  const factory Restaurant({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "city") required String city,
    @JsonKey(name: "address") required String address,
    @JsonKey(name: "pictureId") required String pictureId,
    @JsonKey(name: "categories") required List<Category> categories,
    @JsonKey(name: "menus") required Menus menus,
    @JsonKey(name: "rating") required double rating,
    @JsonKey(name: "customerReviews")
    required List<CustomerReview> customerReviews,
    // @Default(false) bool isFavorite,
  }) = _Restaurant;

  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    @JsonKey(name: "name") required String name,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
class CustomerReview with _$CustomerReview {
  const factory CustomerReview({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "review") required String review,
    @JsonKey(name: "date") required String date,
  }) = _CustomerReview;

  factory CustomerReview.fromJson(Map<String, dynamic> json) =>
      _$CustomerReviewFromJson(json);
}

@freezed
class Menus with _$Menus {
  const factory Menus({
    @JsonKey(name: "foods") required List<Category> foods,
    @JsonKey(name: "drinks") required List<Category> drinks,
  }) = _Menus;

  factory Menus.fromJson(Map<String, dynamic> json) => _$MenusFromJson(json);
}
