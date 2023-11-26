import 'dart:convert';
import 'dart:developer';

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
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

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
        state = const RestaurantState.error("Error, Terjadi kesalahan");
      }
    } catch (e) {
      state = const RestaurantState.error("Error, Terjadi kesalahan");
    }
  }
}

class RestaurantDetailNotifier extends StateNotifier<RestaurantDetailState> {
  RestaurantDetailNotifier() : super(const RestaurantDetailState.loading());

  BaseController baseC = BaseController();

  Future<void> getDetailRestaurant(String id, {bool isRefresh = true}) async {
    try {
      if (isRefresh) {
        state = const RestaurantDetailState.loading();
      }
      final url = '${Constant.baseApi}/detail/$id';
      final response = await baseC.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        state = RestaurantDetailState.data(
            rD.restaurantDetailModelFromJson(response.body));
      } else {
        state = const RestaurantDetailState.error("Error, Terjadi kesalahan");
      }
    } catch (e) {
      state = const RestaurantDetailState.error("Error, Terjadi kesalahan");
    }
  }

  Future<List<String>?> getFavRestaurant() async {
    return prefs.getStringList("fav");
  }

  bool isFav(rD.Restaurant res) {
    List<String>? favRestaurant = prefs.getStringList("fav");
    if (favRestaurant != null && favRestaurant.any((e) => e == res.id)) {
      return true;
    }
    return false;
  }

  Future<void> setFavRestaurant(
      rD.RestaurantDetailModel restaurantModel) async {
    try {
      // pref.clear();
      // rD.Restaurant res = restaurantModel.restaurant;
      List<String>? favRestaurant = prefs.getStringList("fav");
      if (favRestaurant != null) {
        favRestaurant.forEach((e) {
          log("RESTO LIST : $e");
        });
        if (!favRestaurant.any((e) => e == restaurantModel.restaurant.id)) {
          state.whenOrNull(data: (data) {
            data = data.copyWith(
                restaurant: data.restaurant.copyWith(isFavorite: true));
          });
          favRestaurant.add(restaurantModel.restaurant.id);
        } else {
          state.whenOrNull(data: (data) {
            data = data.copyWith(
                restaurant: data.restaurant.copyWith(isFavorite: false));
          });
          favRestaurant.remove(restaurantModel.restaurant.id);
        }
        prefs.setStringList("fav", favRestaurant);
      } else {
        List<String> favTemp = [];
        state.whenOrNull(data: (data) {
          data = data.copyWith(
              restaurant: data.restaurant.copyWith(isFavorite: true));
        });
        favTemp.add(restaurantModel.restaurant.id);
        prefs.setStringList("fav", favTemp);
      }
      state = RestaurantDetailState.data(restaurantModel);
    } catch (e) {
      state = const RestaurantDetailState.error("Gagal Fav");
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
        state = const RestaurantSearchState.error("Error, Terjadi kesalahan");
      }
    } catch (e) {
      state = const RestaurantSearchState.error("Error, Terjadi kesalahan");
    }
  }
}
