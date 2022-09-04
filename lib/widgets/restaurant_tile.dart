import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/restaurant_model.dart';
import '../provider/database_provider.dart';
import 'icon_text.dart';

class RestaurantTile extends StatelessWidget {
  final Restaurant restaurant;
  final Function()? onTap;

  const RestaurantTile({Key? key, required this.restaurant, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      return FutureBuilder<bool>(
          future: provider.isBookmarked(restaurant.id),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                visualDensity: const VisualDensity(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.all(8),
                onTap: onTap,
                trailing: isBookmarked
                    ? IconButton(
                        color: Colors.red,
                        icon: const Icon(Icons.favorite),
                        onPressed: () {
                          provider.deleteBookmark(restaurant.id);
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.favorite_outline),
                        onPressed: () {
                          provider.addBookmark(restaurant);
                        },
                      ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Hero(
                      tag: restaurant.pictureId,
                      child: Image.network(
                        'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      restaurant.name,
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    IconText(
                      textColor: Colors.black,
                      text: restaurant.city,
                      color: Colors.red,
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 10),
                    IconText(
                        textColor: Colors.black,
                        icon: Icons.star,
                        color: Colors.amber,
                        text: restaurant.rating.toString())
                  ],
                ),
              ),
            );
          });
    });
  }
}
