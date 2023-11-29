import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as p;
import 'package:restaurant_app/common/helper/constant.dart';
import 'package:restaurant_app/src/restaurant/controller/database_provider.dart';
import 'package:restaurant_app/src/restaurant/controller/restaurant_provider.dart';
import 'package:restaurant_app/src/restaurant/view/restaurant_detail_view.dart';
import 'package:restaurant_app/src/restaurant/view/restaurant_fav_item.dart';

class RestaurantFavView2 extends ConsumerStatefulWidget {
  const RestaurantFavView2({super.key});

  @override
  ConsumerState<RestaurantFavView2> createState() => _RestaurantFavView2State();
}

class _RestaurantFavView2State extends ConsumerState<RestaurantFavView2> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(restaurantFavProvider.notifier).getRestaurant();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getRest() async {
    ref.read(restaurantFavProvider.notifier).getRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantFavProvider);
    final restaurantNotifier = ref.read(restaurantFavProvider.notifier);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorit"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              restaurant.when(
                loading: () => SizedBox(
                  height: size.height * 0.5,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                error: (error) => Text(error),
                data: (data) {
                  return p.Consumer<DatabaseProvider>(
                    builder: (context, provider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: provider.favourites.isEmpty
                            // child: data.restaurants.isEmpty
                            ? const Text("Data favorit tidak ditemukan")
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.favourites.length,
                                // itemCount: data.restaurants.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  // final item = data.restaurants[index];
                                  final item = provider.favourites[index];
                                  return RestaurantFavItem(
                                    restaurantItem: item,
                                    getRestaurantCallback: getRest,
                                  );
                                },
                              ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
