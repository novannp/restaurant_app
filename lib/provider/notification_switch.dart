import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSwitch extends ChangeNotifier {
  static const String notifPrefs = 'notification';
  bool _isNotificationEnable = true;
  bool get isNotificationEnable => _isNotificationEnable;

  void enableNotification(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(notifPrefs, value);
    _isNotificationEnable = value;
    notifyListeners();
  }

  void loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _isNotificationEnable = prefs.getBool(notifPrefs) ?? true;
    notifyListeners();
  }
}
