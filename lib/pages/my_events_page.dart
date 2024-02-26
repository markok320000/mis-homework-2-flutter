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
  List<DogReport> dogReports = [];
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    getReports();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void getReports() async {
    String username = _userProvider.user.username;
    List<DogReport> fetchedDogReports =
        await ApiMethods().getMyDogReports(username);
    if (mounted) {
      setState(() {
        dogReports = fetchedDogReports;
      });
    }
  }

  void removeDogReport(String dogReportId) async {
    print("Removing dog report with ID: $dogReportId");
    bool res = await ApiMethods().deleteMyDogReport(dogReportId);
    if (res) {
      _userProvider.user.chats.remove(dogReportId);
      setState(() {
        // Update the state to reflect the removal of the dog report
        dogReports.removeWhere((report) => report.id == dogReportId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("My Reports")),
      body: dogReports.isEmpty
          ? Center(
              child: Text(
                "No reports found",
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(children: [
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
                              removeDogReport: removeDogReport,
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
