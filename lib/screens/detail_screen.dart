import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/extensions.dart/remove_scroll_behaviour.dart';
import 'package:restaurant_app/widgets/chip_category.dart';
import 'package:restaurant_app/widgets/menu_listtile.dart';
import 'package:restaurant_app/widgets/review_card.dart';

import '../models/restaurant_model.dart';
import '../navigation.dart';
import '../provider/database_provider.dart';
import '../provider/restaurant_detail_provider.dart';
import '../widgets/icon_text.dart';
import 'package:http/http.dart' as http;

Faker faker = Faker();

class DetailScreen extends StatelessWidget {
  final String id;

  const DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var restaurantDetailProvider =
        Provider.of<RestaurantDetailProvider>(context, listen: false);
    var isReadMore = false;
    return Scaffold(
      body: ScrollConfiguration(
        behavior: RemoveScrollBehaviour(),
        child: StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            if (snapshot.data != ConnectivityResult.none) {
              return buildDetailScreen(restaurantDetailProvider, isReadMore);
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.signal_wifi_off_rounded, size: 80),
                    const Text(' You are not  connected to internet'),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Try again'),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  FutureBuilder<dynamic> buildDetailScreen(
      RestaurantDetailProvider restaurantDetailProvider, bool isReadMore) {
    return FutureBuilder(
      future: restaurantDetailProvider.fetchRestaurantDetail(id, http.Client()),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.runtimeType == Restaurant) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                Restaurant restaurant = snapshot.data;
                return CustomScrollView(
                  slivers: [
                    createSliverAppBar(restaurant, context),
                    SliverList(
                      delegate: SliverChildListDelegate.fixed(
                        [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: restaurant.categories
                                      .map(
                                          (e) => ChipCategory(category: e.name))
                                      .toList(),
                                ),
                                const SizedBox(height: 10),
                                Text('Address : ${restaurant.address}'),
                                const SizedBox(height: 20),
                                buildDescription(restaurant, isReadMore),
                                const SizedBox(height: 20),
                                buildMenu(restaurant, context),
                                const SizedBox(height: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Review',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      children: restaurant.customerReviews
                                          .map(
                                            (e) => ReviewCard(
                                              name: e.name,
                                              date: e.date,
                                              review: e.review,
                                            ),
                                          )
                                          .toList(),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );

              default:
                return const Center(
                  child: Text('Can\'t Load data'),
                );
            }
          } else {
            return Text(snapshot.data);
          }
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Loading...'),
              ],
            ),
          );
        }
      },
    );
  }

  SliverAppBar createSliverAppBar(Restaurant restaurant, BuildContext context) {
    return SliverAppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      pinned: true,
      snap: false,
      expandedHeight: 230,
      toolbarHeight: 40,
      actions: [
        Consumer<DatabaseProvider>(builder: (context, provider, child) {
          return FutureBuilder(
            future: provider.isBookmarked(restaurant.id),
            builder: (context, AsyncSnapshot snapshot) {
              var isBookmarked = snapshot.data ?? false;
              if (isBookmarked) {
                return IconButton(
                  color: Colors.red,
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    provider.deleteBookmark(restaurant.id);
                  },
                );
              }

              return IconButton(
                icon: const Icon(Icons.favorite_outline),
                onPressed: () {
                  provider.addBookmark(restaurant);
                },
              );
            },
          );
        })
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Expanded(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black])),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white,
                          fontSize: 28,
                        ),
                  ),
                ),
                IconText(
                  text: restaurant.city,
                  color: Colors.red,
                  icon: Icons.location_on,
                  textColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Image.network(
          'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
          errorBuilder: (context, error, stackTrace) {
            return const Text('Error, Gagal memuat gambar');
          },
          fit: BoxFit.cover,
        ),
        titlePadding: const EdgeInsets.only(
          left: 50,
          bottom: 24,
          right: 24,
        ),
      ),
    );
  }

  Widget buildMenu(Restaurant restaurant, BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menu',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            TextButton(
              onPressed: () {
                Navigation.intentWithData('/menus', restaurant.menus);
              },
              child: const Text('Lihat menu'),
            )
          ],
        ),
        const SizedBox(height: 10),
        Column(
          children: restaurant.menus.drinks
              .getRange(0, 4)
              .map((e) => MenuListTile(
                  name: e.name,
                  imgUrl: 'assets/images/drink.jpg',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        action: SnackBarAction(
                            label: 'Ok',
                            textColor: Colors.white,
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                            }),
                        backgroundColor: Colors.black,
                        content: Text(
                          'Maaf untuk saat ini belum bisa melakukan pembelian',
                          style:
                              Theme.of(context).textTheme.headline6!.copyWith(
                                    fontSize: 14,
                                    color: Colors.amber,
                                  ),
                        ),
                      ),
                    );
                  }))
              .toList(),
        )
      ],
    );
  }

  StatefulBuilder buildDescription(Restaurant restaurant, bool isReadMore) {
    return StatefulBuilder(
      builder: (context, readMore) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deskripsi',
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              restaurant.description,
              textAlign: TextAlign.justify,
              maxLines: isReadMore ? null : 8,
              overflow:
                  isReadMore ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            InkWell(
              onTap: () {
                readMore(() => isReadMore = !isReadMore);
              },
              child: Text(
                isReadMore ? 'Read less.' : 'Read more..',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        );
      },
    );
  }
}
