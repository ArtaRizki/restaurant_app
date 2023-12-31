import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurant_app/src/restaurant/controller/restaurant_provider.dart';
import 'package:restaurant_app/src/restaurant/view/restaurant_detail_view.dart';

import '../../../common/helper/constant.dart';

class RestaurantSearchView extends ConsumerStatefulWidget {
  const RestaurantSearchView({super.key});

  @override
  ConsumerState<RestaurantSearchView> createState() =>
      _RestaurantSearchViewState();
}

class _RestaurantSearchViewState extends ConsumerState<RestaurantSearchView> {
  TextEditingController searchC = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(restaurantSearchProvider.notifier).getRestaurantSearch();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final restaurantSearch = ref.watch(restaurantSearchProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.only(right: 8),
          child: TextField(
            controller: searchC,
            onChanged: (text) {
              ref
                  .read(restaurantSearchProvider.notifier)
                  .getRestaurantSearch(query: text);
            },
            decoration: InputDecoration(
              hintText: "Cari Restoran...",
              contentPadding: const EdgeInsets.only(
                  left: 15, bottom: 11, top: 11, right: 15),
              suffixIcon: GestureDetector(
                onTap: () {
                  searchC.text = "";

                  ref
                      .read(restaurantSearchProvider.notifier)
                      .getRestaurantSearch();
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.close),
                ),
              ),
              suffixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              focusColor: Colors.blue,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: restaurantSearch.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error) => Text(error),
              data: (data) => data.restaurants.isEmpty
                  ? const Text("Data tidak ditemukan")
                  : ListView.separated(
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
          ),
        ),
      ),
    );
  }
}
