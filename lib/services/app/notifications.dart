import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// This is a service class that handles local notifications
// It is not used right now, but it is a good example of how to use the plugin
class NotificationService {
  FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    debugPrint('Initializing notifications..');
    notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_stat_blur_on');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // your call back to the UI to show notification
      },
    );

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  // This is needed for showNotification
  _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        icon: 'ic_stat_blur_on',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  // Displays a local notification
  // I really don't know why payload needs to be there
  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    debugPrint('Trying to show notification');
    return notificationPlugin.show(
      id,
      title,
      body,
      await _notificationDetails(),
    );
  }
}
