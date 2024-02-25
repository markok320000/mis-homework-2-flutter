import 'package:event_scheduler_project/api/notification_api.dart';
import 'package:event_scheduler_project/models/eventMode.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/api/api_methods.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/event_card.dart';
import '../models/dogReportModel.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});
  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  DateTime currentDate = DateTime.now();
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<DogReport> dogReports = [];

  @override
  void initState() {
    getReports();
    super.initState();
  }

  void getReports() async {
    List<DogReport> fetchedDogReports = await ApiMethods().fetchDogReports();
    setState(() {
      dogReports = fetchedDogReports;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("My Events Page")),
      body: Column(children: [
        Expanded(
          child: CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 1,
                  children: <Widget>[
                    ...dogReports.map((report) {
                      return EventCard(
                        dogReport: report,
                        isInMyReports: true,
                      );
                    }).toList(),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}
