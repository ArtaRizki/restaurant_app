import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_model.dart';

part 'restaurant_state.freezed.dart';

@freezed
abstract class RestaurantState with _$RestaurantState {
  // factory RestaurantState({required RestaurantModel restaurantModel}) =
  //     _RestaurantState;

  const factory RestaurantState.data(RestaurantModel restaurantModel) = _Data;
  const factory RestaurantState.error(String errorText) = _Error;
  const factory RestaurantState.loading() = _Loading;
}
