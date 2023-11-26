import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/helper/constant.dart';
import '../controller/restaurant_provider.dart';

class RestaurantDetailView extends ConsumerStatefulWidget {
  const RestaurantDetailView({super.key, required this.id, required this.name});
  final String id;
  final String name;

  @override
  ConsumerState<RestaurantDetailView> createState() =>
      _RestaurantDetailViewState();
}

class _RestaurantDetailViewState extends ConsumerState<RestaurantDetailView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(restaurantDetailProvider.notifier)
          .getDetailRestaurant(widget.id);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantDetail = ref.watch(restaurantDetailProvider);
    final restaurantRead = ref.read(restaurantDetailProvider.notifier);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: true,
        title: Text(widget.name),
      ),
      body: restaurantDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error) => Text(error),
        data: (data) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: size.height * 0.4,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                        child: CachedNetworkImage(
                          placeholder: (context, _) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          imageUrl: Constant.imageUrlLarge +
                              data.restaurant.pictureId,
                          errorWidget: (context, _, __) {
                            return const Text("Gambar Error");
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text(data.restaurant.name,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: IconButton(
                                  onPressed: () =>
                                      restaurantRead.setFavRestaurant(data)
                                  // .then((value) => restaurantRead
                                  //     .getDetailRestaurant(widget.id,
                                  //         isRefresh: false
                                  //         )
                                  //         )
                                  ,
                                  icon: Icon(
                                    // data.restaurant.isFavorite
                                    restaurantRead.isFav(data.restaurant)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 15,
                              ),
                              const SizedBox(width: 2),
                              Text(data.restaurant.city),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 15,
                              ),
                              const SizedBox(width: 2),
                              Text("${data.restaurant.rating}"),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const Text("Deskripsi",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(data.restaurant.description,
                              style: const TextStyle()),
                          const SizedBox(height: 16),
                          const Text("Menu Makanan",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 16,
                      crossAxisCount: 2,
                      children: List.generate(
                        data.restaurant.menus.foods.length,
                        (index) {
                          final food = data.restaurant.menus.foods[index];
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    food.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Menu Minuman",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                    GridView.count(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      crossAxisCount: 2,
                      children: List.generate(
                        data.restaurant.menus.drinks.length,
                        (index) {
                          final drink = data.restaurant.menus.drinks[index];
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    drink.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
