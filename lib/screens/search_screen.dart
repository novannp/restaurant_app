import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/restaurants_model.dart';
import '../provider/restaurant_search_provider.dart';
import '../widgets/restaurant_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var restaurantSearchProvider =
        Provider.of<RestaurantSearchProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 20),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextFormField(
                    onFieldSubmitted: (newValue) {
                      setState(() {});
                    },
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontSize: 16),
                    decoration: InputDecoration(
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      hintText: 'Cari Restaurant',
                      hintStyle:
                          Theme.of(context).textTheme.headline6!.copyWith(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                    ),
                  ),
                ),
              ),
              Text('Hasil Pencarian \'${searchController.text}\''),
              const SizedBox(height: 20),
              searchController.text.isEmpty
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.search,
                            size: 80,
                          ),
                          Text('Cari restaurant terbaik disini ')
                        ],
                      ),
                    )
                  : StreamBuilder<ConnectivityResult>(
                      stream: Connectivity().onConnectivityChanged,
                      builder: (context, snapshot) {
                        if (snapshot.data != ConnectivityResult.none) {
                          return buildSearchResult(restaurantSearchProvider);
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.signal_wifi_off_rounded,
                                  size: 80),
                              const Text(' You are not  connected to internet'),
                              TextButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  child: const Text('Try again'))
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        )),
      ),
    );
  }

  FutureBuilder<dynamic> buildSearchResult(
      RestaurantSearchProvider restaurantProvider) {
    return FutureBuilder(
      future: restaurantProvider.fetchSearchResult(searchController.text),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.runtimeType == Restaurants) {
            Restaurants restaurants = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (restaurants.restaurants.isEmpty) {
                  return const Center(
                    child: Text('Pencarian tidak ditemukan'),
                  );
                } else {
                  return Column(
                      children: restaurants.restaurants
                          .map(
                            (e) => RestaurantTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/details',
                                  arguments: e.id,
                                );
                              },
                              restaurant: e,
                            ),
                          )
                          .toList());
                }
              default:
                return Text('${snapshot.data}');
            }
          } else {
            return Material(
              child: Text(snapshot.data),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
