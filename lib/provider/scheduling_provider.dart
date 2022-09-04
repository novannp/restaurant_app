import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import '../service/background_service.dart';
import '../service/date_time_service.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;
  bool get isScheduled => _isScheduled;

  Future<bool> scheduleRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeService.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();

      return await AndroidAlarmManager.cancel(1);
    }
  }
}
