import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:event_scheduler_project/api/firebase_api.dart';
import 'package:event_scheduler_project/api/notification_api.dart';
import 'package:event_scheduler_project/config/app_routes.dart';
import 'package:event_scheduler_project/firebase_options.dart';
import 'package:event_scheduler_project/pages/home_page.dart';
import 'package:event_scheduler_project/pages/login_page.dart';
import 'package:event_scheduler_project/pages/main_page.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/styles/app_colors.dart';
import 'package:event_scheduler_project/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'models/eventMode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  NotificationApi flutterLocalNotificationsPlugin = new NotificationApi();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: "channel_events",
        channelName: "Events Channel",
        channelDescription: "Description for channel events",
        channelGroupKey: "channel_events_group"),
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "channel_events_group",
        channelGroupName: "Events Channel"),
  ]);
  List<Event> eventsNotified = [];
  final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  const thirtySec = const Duration(seconds: 30);
  new Timer.periodic(
      thirtySec, (Timer t) => notifyNearByEvent(position, eventsNotified));

  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();

  if (!isAllowedToSendNotifications) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'Urbanist',
            scaffoldBackgroundColor: AppColors.background,
            brightness: Brightness.dark),
        // initialRoute: AppRoutes.main,
        // routes: AppRoutes.pages,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const MainPage();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginPage();
          },
        ),
      ),
    );
  }
}
