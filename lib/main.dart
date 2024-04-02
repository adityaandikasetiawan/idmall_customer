import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:idmall/consts.dart';
import 'package:idmall/pages/navigation.dart';
import 'package:idmall/service/coverage_area.dart';
import 'package:idmall/service/notification_controller.dart';
import 'package:idmall/splash/splash.dart';
import 'package:idmall/widget/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Initializing Firebase...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    print("Firebase initialization completed.");
  });
  String? token;
  String? fcm_token;
  SharedPreferences? _pref = await SharedPreferences.getInstance();
  token = _pref.getString('token') ?? '';
  FirebaseMessaging.instance.getToken().then((value) async {
    print("Token: $value");

    if (value != null) {
      _pref.setString('fcm_token', value);
      if (token != null) {
        (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
            HttpClient()
              ..badCertificateCallback =
                  (X509Certificate cert, String host, int port) => true;
        final response = await dio.post(
          "$linkLaravelAPI/customer/update-device-key",
          data: {"token": value},
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
          }),
        );
        print(response);
      }
    }
    // csvzsOX1Rtifk2f0xUeUam:APA91bHnZK_XFVE6_2s--UqYcIv7N2pzOgFWXe-xpr5ej7nNrvCMQxIiNhioRhREDUt2zdba5xJOLQxL3tTNX35O_n4g_qcV8UMdexfvlkYdW5OUQPaGDJ499XK2f78ekf-A5ZiITPJl
  });

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
          defaultColor: Color(0xFF9D50DD),
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
      print(message);
      print(1);
      // Navigator.of(navigatorKey.currentState!.context).pushNamed('/push-page', arguments: {"message", json.encode(message.data)});
    }
  });

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  Stripe.publishableKey = publishableKey;
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    // print foreground message here.
    print("OVER HERE");
    print('Handling a foreground message ${message.messageId}');
    print('Notification Message: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification:  ${message.notification}');
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: UniqueKey().hashCode,
        channelKey: "basic_channel",
        title: message.notification?.title,
        body: message.notification?.body,
      ));
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpened App; $message");
    // Navigator.of(navigatorKey.currentState!.context).pushNamed('/push-page', arguments: {"message", json.encode(message.data)});
    // push(
    //   MaterialPageRoute(builder: (builder) => PushNotificationOnAll()),
    //   arguments: {"message", json.encode(message)},
    // );
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpened App; $message");
    // Navigator.of(navigatorKey.currentState!.context).pushNamed('/push-page', arguments: {"message", json.encode(message.data)});
  });

  runApp(MyApp(
    token: token,
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("_firebaseMessagingBackgroundHandler: $message");
}

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
    // TODO: implement initState
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
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: widget.token == '' ? Splash() : NavigationScreen(),
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
      title: 'Flutter Demo',
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
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
