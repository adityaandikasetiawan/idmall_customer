// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:idmall/pages/navigation.dart';
import 'package:idmall/service/coverage_area.dart';
import 'package:idmall/service/notification_controller.dart';
import 'package:idmall/splash/splash.dart';
import 'package:idmall/widget/app_constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:idmall/config/config.dart' as config;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {});
  String? token;
  SharedPreferences? pref = await SharedPreferences.getInstance();
  token = pref.getString('token') ?? '';
  FirebaseMessaging.instance.getToken().then(
    (value) async {
      if (value != null) {
        pref.setString('fcm_token', value);
        if (token != null && token != '') {
          await dio.post(
            "${config.backendBaseUrl}/update-device-key",
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token",
                "Cache-Control": "no-cache"
              },
            ),
            data: {
              "token": value,
            },
          );
        }
      }
    },
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "basic_channel",
          channelName: "Basic Notifications",
          channelDescription: "Basic Notification Channel",
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: "basic_channel_group",
            channelGroupName: "Basip Group")
      ],
      debug: true);

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      // Navigator.of(navigatorKey.currentState!.context).pushNamed('/push-page', arguments: {"message", json.encode(message.data)});
    }
  });

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  Stripe.publishableKey = publishableKey;

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    // Navigator.of(navigatorKey.currentState!.context).pushNamed('/push-page', arguments: {"message", json.encode(message.data)});
    // push(
    //   MaterialPageRoute(builder: (builder) => PushNotificationOnAll()),
    //   arguments: {"message", json.encode(message)},
    // );
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    // Navigator.of(navigatorKey.currentState!.context).pushNamed('/push-page', arguments: {"message", json.encode(message.data)});
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print foreground message here.

    if (message.notification != null) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: UniqueKey().hashCode,
        channelKey: "basic_channel",
        title: message.notification?.title,
        body: message.notification?.body,
      ));
    }
  });

  runApp(MyApp(
    token: token,
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  String token;
  MyApp({super.key, required this.token});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? awal;

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return const CheckSharedPreferences();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Idmall',
      home: widget.token == '' ? const Splash() : const NavigationScreen(),
      // home: EmptyPage(),
      navigatorKey: navigatorKey,
      // routes: {
      //   '/push-page' : ((context) => PushNotificationOnAll()),
      // },
    );
  }
}

class CheckSharedPreferences extends StatefulWidget {
  const CheckSharedPreferences({super.key});

  @override
  _CheckSharedPreferencesState createState() => _CheckSharedPreferencesState();
}

class _CheckSharedPreferencesState extends State<CheckSharedPreferences> {
  String valueFromSharedPreferences = '';

  @override
  void initState() {
    super.initState();
    _checkSharedPreferences();
  }

  Future<void> _checkSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      valueFromSharedPreferences = prefs.getString('token') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Idmall',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 251, 251, 251)),
        useMaterial3: true,
      ),
      home: valueFromSharedPreferences == ''
          ? const Splash()
          : const NavigationScreen(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
