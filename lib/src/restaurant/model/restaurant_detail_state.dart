import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_detail_model.dart';

part 'restaurant_detail_state.freezed.dart';

@freezed
abstract class RestaurantDetailState with _$RestaurantDetailState {
  const factory RestaurantDetailState.data(
      RestaurantDetailModel restaurantDetailModel) = _Data;
  const factory RestaurantDetailState.error(String errorText) = _Error;
  const factory RestaurantDetailState.loading() = _Loading;
}
