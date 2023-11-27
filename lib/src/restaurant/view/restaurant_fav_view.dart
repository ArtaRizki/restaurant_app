import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/common/helper/constant.dart';
import 'package:restaurant_app/src/restaurant/controller/restaurant_provider.dart';
import 'package:restaurant_app/src/restaurant/view/restaurant_detail_view.dart';

class RestaurantFavView extends ConsumerStatefulWidget {
  const RestaurantFavView({super.key});

  @override
  ConsumerState<RestaurantFavView> createState() => _RestaurantFavViewState();
}

class _RestaurantFavViewState extends ConsumerState<RestaurantFavView> {
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

  @override
  Widget build(BuildContext context) {
    final restaurant = ref.watch(restaurantFavProvider);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorit"),
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
                  return SizedBox(
                    width: double.infinity,
                    child: data.restaurants.isEmpty
                        ? const Text("Data favorit tidak ditemukan")
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.restaurants.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 16),
                            itemBuilder: (context, index) {
                              final item = data.restaurants[index];
                              return InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RestaurantDetailView(
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
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                          imageUrl: Constant.imageUrlSmall +
                                              item.pictureId,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
