import 'dart:developer';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/main.dart';

import '../../../common/helper/bg_service.dart';
import '../../../common/helper/datetime.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduled = false;

  bool isScheduled() {
    _isScheduled = prefs.getBool('schedule') ?? false;
    return _isScheduled;
  }

  Future<bool> scheduledRestaurant(bool value) async {
    _isScheduled = value;
    if (_isScheduled) {
      prefs.setBool('schedule', true);
      log('Scheduling Restaurant Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(minutes: 1),
        1,
        BackgroundService.callback,
        startAt: DateTime.now(),
        // startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      prefs.setBool('schedule', false);
      log('Scheduling Restaurant Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
