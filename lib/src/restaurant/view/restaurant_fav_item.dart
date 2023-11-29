import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/helper/constant.dart';
import '../controller/database_provider.dart';
import '../model/restaurant_model.dart';
import 'restaurant_detail_view.dart';

class RestaurantFavItem extends StatelessWidget {
  final Restaurant restaurantItem;
  final Function() getRestaurantCallback;

  const RestaurantFavItem({
    Key? key,
    required this.restaurantItem,
    required this.getRestaurantCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isFavourited(restaurantItem.id),
          builder: (context, snapshot) {
            var isFavourited = snapshot.data ?? false;
            return InkWell(
              onTap: () async {
                final refresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RestaurantDetailView(
                            id: restaurantItem.id,
                            name: restaurantItem.name,
                            refresh: true)));
                if (refresh != null) {
                  getRestaurantCallback;
                }
              },
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
                            Constant.imageUrlSmall + restaurantItem.pictureId,
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
                          restaurantItem.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                            Text(restaurantItem.city),
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
                            Text("${restaurantItem.rating}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
