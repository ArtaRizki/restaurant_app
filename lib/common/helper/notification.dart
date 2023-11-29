import 'dart:convert';
import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/helper/navigation.dart';
import 'package:restaurant_app/src/restaurant/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse details) async {
      final payload = details.payload;
      if (payload != null) {
        log('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
      configureSelectNotificationSubject();
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      Restaurant restaurants) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "restaurant app channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Coba Liat Restaurant Ini</b>";
    var titleRestaurant = restaurants.name;

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpecifics,
        payload: jsonEncode(restaurants.toJson()));
  }

  void configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = Restaurant.fromJson(json.decode(payload));
        Navigation.intentWithData(data);
      },
    );
  }
}
