import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/widgets/restaurant_tile.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
        elevation: 0,
      ),
      body: SingleChildScrollView(child:
          Consumer<DatabaseProvider>(builder: (context, provider, child) {
        if (provider.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 300,
                ),
                Icon(
                  Icons.close,
                  size: 60,
                ),
                Text('Favorite Anda kosong'),
              ],
            ),
          );
        }
        return Column(
          children: provider.favorites
              .map((e) => RestaurantTile(restaurant: e))
              .toList(),
        );
      })),
    );
  }
}
