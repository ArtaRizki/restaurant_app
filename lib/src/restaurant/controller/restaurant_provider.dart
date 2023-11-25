import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/helper/constant.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_detail_model.dart'
    as rD;
import 'package:restaurant_app/src/restaurant/model/restaurant_model.dart'
    as rM;
import 'package:restaurant_app/common/base/base_controller.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_detail_state.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_search_model.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_search_state.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_state.dart';

final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantState>(
        (ref) => RestaurantNotifier());
final restaurantDetailProvider =
    StateNotifierProvider<RestaurantDetailNotifier, RestaurantDetailState>(
        (ref) => RestaurantDetailNotifier());
final restaurantSearchProvider =
    StateNotifierProvider<RestaurantSearchNotifier, RestaurantSearchState>(
        (ref) => RestaurantSearchNotifier());

class RestaurantNotifier extends StateNotifier<RestaurantState> {
  RestaurantNotifier() : super(const RestaurantState.loading()) {
    getRestaurant();
  }

  BaseController baseC = BaseController();

  Future<void> getRestaurant() async {
    try {
      state = const RestaurantState.loading();
      const url = '${Constant.baseApi}/list';
      final response = await baseC.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        state = RestaurantState.data(rM.restaurantModelFromJson(response.body));
      } else {
        final message = jsonDecode(response.body)["message"];
        state = RestaurantState.error(message);
        throw Exception(message);
      }
    } catch (e) {
      state = RestaurantState.error(e.toString());
      throw (Exception(e.toString()));
    }
  }
}

class RestaurantDetailNotifier extends StateNotifier<RestaurantDetailState> {
  RestaurantDetailNotifier() : super(const RestaurantDetailState.loading());

  BaseController baseC = BaseController();

  Future<void> getDetailRestaurant(String id) async {
    try {
      state = const RestaurantDetailState.loading();
      final url = '${Constant.baseApi}/detail/$id';
      final response = await baseC.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        state = RestaurantDetailState.data(
            rD.restaurantDetailModelFromJson(response.body));
      } else {
        final message = jsonDecode(response.body)["message"];
        throw Exception(message);
      }
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }
}

class RestaurantSearchNotifier extends StateNotifier<RestaurantSearchState> {
  RestaurantSearchNotifier() : super(const RestaurantSearchState.loading());

  BaseController baseC = BaseController();

  Future<void> getRestaurantSearch({String query = ""}) async {
    try {
      state = const RestaurantSearchState.loading();
      const url = '${Constant.baseApi}/search';
      final response = await baseC.get(url, query: {'q': query});
      if (response.statusCode == 200 || response.statusCode == 201) {
        state = RestaurantSearchState.data(
            restaurantSearchModelFromJson(response.body));
      } else {
        final message = jsonDecode(response.body)["message"];
        throw Exception(message);
      }
    } catch (e) {
      throw (Exception(e.toString()));
    }
  }
}
