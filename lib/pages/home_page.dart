import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:event_scheduler_project/api/notification_api.dart';
import 'package:event_scheduler_project/components/event_card.dart';
import 'package:event_scheduler_project/models/eventMode.dart';
import 'package:event_scheduler_project/models/user.dart';
import 'package:event_scheduler_project/pages/my_events_page.dart';
import 'package:event_scheduler_project/resources/api/api_methods.dart';
import 'package:event_scheduler_project/resources/auth_methods.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:flutter/material.dart';

import '../models/dogReportModel.dart';
import '../utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int eventsToday = 0;
  List<Event> events = [];
  List<DogReport> dogReports = [];

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationApi.onActionRecievedMethod,
      onDismissActionReceivedMethod:
          NotificationApi.onDismissActionReceivedMethod,
      onNotificationCreatedMethod: NotificationApi.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationApi.onNotificationDisplayedMethod,
    );
    super.initState();
    getReports();

    // getEvents();
  }

  Future<void> getReports() async {
    List<DogReport> fetchedDogReports = await ApiMethods().fetchDogReports();
    if (mounted) {
      setState(() {
        dogReports = fetchedDogReports;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dog Reports')),
      body: Container(
        child: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  ...dogReports.map((report) {
                    return EventCard(
                      removeDogReport: (id) {},
                      dogReport: report,
                    );
                  }).toList(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
