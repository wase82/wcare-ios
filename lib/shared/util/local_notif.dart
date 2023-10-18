import 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Android
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'wton_care_channel', // id
  'WCare_Notification_Application', // titled
  description: 'Wton Care Notification',
  showBadge: true,
  playSound: true,
  enableVibration: true,
  importance: Importance.high,
);
var initializationSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
  channel.id,
  channel.name,
  channelDescription: channel.description,
  importance: channel.importance,
  styleInformation: const BigTextStyleInformation(''),
);

const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings();
const LinuxInitializationSettings initializationSettingsLinux =
    LinuxInitializationSettings(defaultActionName: 'Open notification');
final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux);

// General
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
