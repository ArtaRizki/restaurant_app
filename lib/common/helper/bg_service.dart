import 'dart:developer';
import 'dart:ui';
import 'dart:isolate';
import '../../main.dart';

import '../../src/restaurant/model/restaurant_model.dart';
import '../base/base_controller.dart';
import 'constant.dart';
import 'notification.dart';

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
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    log('Alarm fired!');

    BaseController baseC = BaseController();
    final NotificationHelper notificationHelper = NotificationHelper();
    const url = '${Constant.baseApi}/list';
    final result = await baseC.get(url);
    var data = restaurantModelFromJson(result.body);
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, data);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
