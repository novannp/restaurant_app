import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/extensions.dart/remove_scroll_behaviour.dart';
import 'package:restaurant_app/models/restaurants_model.dart';
import 'package:restaurant_app/provider/restaurants_provider.dart';
import 'package:restaurant_app/widgets/restaurant_tile.dart';

import '../main.dart';
import '../navigation.dart';
import '../service/background_service.dart';
import '../service/date_time_service.dart';
import '../service/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Restaurants restaurants;
  final double _expandedHeight = 150;
  final Connectivity _connectivity = Connectivity();
  final NotificationService _notificationService = NotificationService();
  bool hasInternet = false;

  @override
  void initState() {
    _notificationService.configureSelectNotificationSubject('/details');
    _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        hasInternet = false;
      } else {
        hasInternet = true;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ScrollConfiguration(
        behavior: RemoveScrollBehaviour(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              pinned: true,
              actions: [
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pushNamed(context, '/favorites');
                  },
                  icon: const Icon(Icons.favorite),
                ),
                IconButton(
                  iconSize: 20,
                  onPressed: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  icon: const Icon(Icons.settings),
                )
              ],
              collapsedHeight: 90,
              expandedHeight: _expandedHeight,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Container(color: Colors.black),
                centerTitle: true,
                titlePadding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.restaurant,
                      color: Colors.white,
                    ),
                    AutoSizeText(
                      'Restaurant App',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.white,
                          ),
                      maxLines: 1,
                    )
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 24),
                        height: 100,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.lunch_dining_rounded,
                              color: Colors.black,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TyperAnimatedText('Welcome !'),
                                TyperAnimatedText('Stay Healty !'),
                                TyperAnimatedText('Stay Safe !')
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(
                          minHeight: 1000,
                          minWidth: double.infinity,
                        ),
                        margin: const EdgeInsets.only(top: 50),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 243, 243, 243),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Text(
                              'Recommended',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            AutoSizeText(
                              'Recommendation restaurant for you!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 14),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 20),
                            StreamBuilder<ConnectivityResult>(
                                stream: _connectivity.onConnectivityChanged,
                                builder: (context, snapshot) {
                                  if (!hasInternet) {
                                    return noInternetDisplay();
                                  } else if (hasInternet != false) {
                                    return buildRestaurantList();
                                  } else {
                                    return noInternetDisplay();
                                  }
                                })
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Center noInternetDisplay() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.signal_wifi_off_rounded, size: 80),
          const Text(' You are not  connected to internet'),
          TextButton(onPressed: () {}, child: const Text('Try again'))
        ],
      ),
    );
  }

  Widget buildRestaurantList() {
    return Consumer<RestaurantsProvider>(
      builder: (context, provider, child) {
        if (hasInternet == false) {
          return const Center(child: Text('Connection Lost'));
        }
        if (provider.state == ResultState.loading) {
          if (provider.state == ResultState.error) {
            return const Text('Connection Lost');
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        } else if (provider.state == ResultState.hasData) {
          return Column(
            children: provider.restaurants.restaurants
                .map((restaurant) => RestaurantTile(
                      onTap: () {
                        Navigation.intentWithData('/details', restaurant.id);
                      },
                      restaurant: restaurant,
                    ))
                .toList(),
          );
        } else if (provider.state == ResultState.dataEmpty) {
          return Material(
            child: Text(provider.message),
          );
        } else {
          return Material(
            child: Text(provider.message),
          );
        }
      },
    );
  }
}
