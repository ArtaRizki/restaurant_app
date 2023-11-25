import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_search_model.dart';

part 'restaurant_search_state.freezed.dart';

@freezed
abstract class RestaurantSearchState with _$RestaurantSearchState {
  // factory RestaurantSearchState({required RestaurantModel restaurantModel}) =
  //     _RestaurantSearchState;

  const factory RestaurantSearchState.data(
      RestaurantSearchModel restaurantSearchModel) = _Data;
  const factory RestaurantSearchState.error(String errorText) = _Error;
  const factory RestaurantSearchState.loading() = _Loading;
}
