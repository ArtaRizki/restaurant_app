import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/helper/constant.dart';
import 'package:restaurant_app/src/restaurant/controller/restaurant_provider.dart';
import 'package:restaurant_app/src/restaurant/view/restaurant_detail_view.dart';
import 'package:restaurant_app/src/restaurant/view/restaurant_search_view%20.dart';

class RestaurantView extends ConsumerStatefulWidget {
  const RestaurantView({super.key});

  @override
  ConsumerState<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends ConsumerState<RestaurantView> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   ref.read(restaurantProvider.notifier).getRestaurant();
    // });
    super.initState();
  }

  @override
  void dispose() {
    ref.read(restaurantProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 56),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Restaurant",
                      style: TextStyle(fontSize: 28, color: Colors.black87)),
                  IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const RestaurantSearchView())),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ],
              ),
              const Text("Resto rekomendasi untukmu!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black26)),
              const SizedBox(height: 32),
              restaurant.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error) => Text(error),
                data: (data) => SizedBox(
                  width: double.infinity,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.restaurants.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = data.restaurants[index];
                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RestaurantDetailView(
                                    id: item.id, name: item.name))),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  placeholder: (context, _) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  },
                                  imageUrl:
                                      Constant.imageUrlSmall + item.pictureId,
                                  errorWidget: (context, _, __) {
                                    return const Text("Gambar Error");
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              flex: 7,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(item.city),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.orange,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 2),
                                      Text("${item.rating}"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
