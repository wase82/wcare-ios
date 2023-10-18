import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wtoncare/bloc/authentication_process/authentication_process_bloc.dart';
import 'package:wtoncare/bloc/device/device_bloc.dart';
import 'package:wtoncare/bloc/laporanku/laporanku_bloc.dart';
import 'package:wtoncare/bloc/list_laporan/list_laporan_bloc.dart';
import 'package:wtoncare/bloc/notif/notif_bloc.dart';
import 'package:wtoncare/bloc/performa/performa_bloc.dart';
import 'package:wtoncare/bloc/services/services_bloc.dart';
import 'package:wtoncare/router/router.dart';
import 'package:wtoncare/shared/util/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'shared/util/local_notif.dart';

var initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
  iOS: initializationSettingsDarwin,
);
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: androidNotificationDetails,
      ),
      payload: message.data['id'],
    );
    String? dataId = message.data['id'];
    if (dataId != null) {
      backNotif = true;
      backPayload = dataId;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (Platform.isAndroid) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  } else if (Platform.isIOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          break;
      }
    },
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    onForeground();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _runWhileAppIsTerminated());
    super.initState();
  }

  void _runWhileAppIsTerminated() async {
    NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null) {
      if (details.didNotificationLaunchApp) {
        if (details.notificationResponse?.payload != null) {
          payload = details.notificationResponse!.payload!;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DeviceBloc(),
        ),
        BlocProvider(
          create: (context) => AuthenticationProcessBloc(),
        ),
        BlocProvider(
          create: (context) => ServicesBloc(),
        ),
        BlocProvider(
          create: (context) => ListLaporanBloc(),
        ),
        BlocProvider(
          create: (context) => LaporankuBloc(),
        ),
        BlocProvider(
          create: (context) => PerformaBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Wton Care',
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        onGenerateRoute: MyRoute.generateRoute,
      ),
    );
  }

  void onForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.data['title'],
          message.data['body'],
          NotificationDetails(
            android: androidNotificationDetails,
          ),
          payload: message.data['id'],
        );
        String? dataId = message.data['id'];
        if (dataId != null) {
          backNotif = true;
          backPayload = dataId;
        }
      }
    });
  }
}
