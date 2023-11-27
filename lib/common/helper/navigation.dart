import 'package:flutter/material.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_model.dart';
import 'package:restaurant_app/src/restaurant/view/restaurant_detail_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Navigation {
  static intentWithData(Restaurant res) {
    navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) =>
            RestaurantDetailView(id: res.id, name: res.name)));
  }

  static back() => navigatorKey.currentState?.pop();
}
