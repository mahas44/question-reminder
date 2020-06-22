import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  var flutterLocalNotificationsPlugin;

NotificationAppLaunchDetails notificationAppLaunchDetails;

  NotificationManager() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    initNotifications();
  }

  getNotificationInstance() {
    return flutterLocalNotificationsPlugin;
  }

  void initNotifications() {
    var initializationSettingAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettingIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingAndroid, initializationSettingIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void showNotifitions(int id, String title, String body, DateTime dateTime) async{
    await flutterLocalNotificationsPlugin.schedule(id, title, body, dateTime, getPlatformChannelSpecfics());
    print('Notification Succesfully Scheduled at ${dateTime.toString()}');
  }

  getPlatformChannelSpecfics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'Question Reminder');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    return platformChannelSpecifics;
  }

  Future onSelectNotification(String payload) async {
    print('Notification clicked');
    return Future.value(0);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    
    return Future.value(1);
  }

  void removeReminder(int notificationId) {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
