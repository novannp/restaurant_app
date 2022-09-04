import 'dart:ui';
import 'dart:isolate';

import '../main.dart';
import 'api_service.dart';
import 'notification_service.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;

  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
  }

  static Future<void> callback() async {
    final NotificationService notificationService = NotificationService();
    var result = await ApiService().getRestaurantList();
    await notificationService.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
