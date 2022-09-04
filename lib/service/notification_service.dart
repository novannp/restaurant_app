import 'dart:convert';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import '../models/restaurants_model.dart';
import 'package:restaurant_app/navigation.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationService {
  Random random = Random();
  late int randomIndex;

  static NotificationService? _instance;

  NotificationService._internal() {
    _instance = this;
  }

  factory NotificationService() => _instance ?? NotificationService._internal();

  Future<void> initialNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        // print('notif : $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurants restaurants) async {
    var channelId = '1';
    var channelName = 'channel_1';
    var channelDesc = 'Restaurant Channel';
    randomIndex = random.nextInt(restaurants.restaurants.length);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );
    var platformChannelSpecific =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    var titleNotification = '<b>New Restaurant </b>';
    var titleNews = restaurants.restaurants[randomIndex].name;

    await flutterLocalNotificationsPlugin.show(
      0,
      titleNotification,
      titleNews,
      platformChannelSpecific,
      payload: json.encode(
        restaurants.toJson(),
      ),
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen((event) {
      (String payload) async {
        var data = Restaurants.fromJson(jsonDecode(payload));
        var restaurant = data.restaurants[randomIndex];
        Navigation.intentWithData(route, restaurant.id);
      };
    });
  }
}
