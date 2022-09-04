import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/navigation.dart';
import 'package:restaurant_app/provider/database_provider.dart';
import 'package:restaurant_app/provider/notification_switch.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/restaurants_provider.dart';
import 'package:restaurant_app/screens/favorite_screen.dart';
import 'package:restaurant_app/screens/detail_screen.dart';
import 'package:restaurant_app/screens/search_screen.dart';
import 'package:restaurant_app/screens/settings_screen.dart';
import 'package:restaurant_app/screens/splash_screen.dart';
import 'package:restaurant_app/service/api_service.dart';
import 'package:restaurant_app/service/background_service.dart';
import 'package:restaurant_app/service/database_service.dart';
import 'package:restaurant_app/service/notification_service.dart';

import 'models/menus_model.dart';
import 'provider/scheduling_provider.dart';
import 'screens/home_screen.dart';
import 'screens/menus_screen.dart';
import 'theme.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationService notificationService = NotificationService();
  final BackgroundService backgroundService = BackgroundService();

  backgroundService.initializeIsolate();

  await AndroidAlarmManager.initialize();
  await notificationService
      .initialNotification(flutterLocalNotificationsPlugin);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => RestaurantsProvider(apiService: ApiService())),
      ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(ApiService())),
      ChangeNotifierProvider(
          create: (_) => RestaurantSearchProvider(ApiService())),
      ChangeNotifierProvider(
          create: (_) => DatabaseProvider(DatabaseService())),
      ChangeNotifierProvider(
        create: (_) => SchedulingProvider(),
        child: const SettingsScreen(),
      ),
      ChangeNotifierProvider(create: (_) => NotificationSwitch())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      theme: CustomTheme.lightTheme(context),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/details': (context) => DetailScreen(
            id: ModalRoute.of(context)!.settings.arguments as String),
        '/menus': (context) => MenusScreen(
              menus: ModalRoute.of(context)!.settings.arguments as Menus,
            ),
        '/search': (context) => const SearchScreen(),
        '/favorites': (context) => const FavoriteScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
