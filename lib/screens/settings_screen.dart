import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/notification_switch.dart';

import '../provider/scheduling_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: ListTile(
          title: const Text('Restaurant Notification'),
          subtitle: const Text('Active notification'),
          trailing: Consumer2<SchedulingProvider, NotificationSwitch>(
            builder: (context, schedule, notifSwitch, child) {
              notifSwitch.loadNotificationSetting();
              return Switch(
                  value: notifSwitch.isNotificationEnable,
                  onChanged: (value) {
                    schedule.scheduleRestaurant(value);
                    notifSwitch.enableNotification(value);
                  });
            },
          )),
    );
  }
}
