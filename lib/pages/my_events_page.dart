import 'package:event_scheduler_project/api/notification_api.dart';
import 'package:event_scheduler_project/models/eventMode.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/event_card.dart';

class MyEventsPage extends StatefulWidget {
  const MyEventsPage({super.key});
  @override
  State<MyEventsPage> createState() => _MyEventsPageState();
}

class _MyEventsPageState extends State<MyEventsPage> {
  TextEditingController _dateController = TextEditingController();
  DateTime currentDate = DateTime.now();
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _dateController.text = currentDate.toString().split(" ")[0];
    scheduleNotificationTomorrow(currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    print(userProvider.getUser.myEvents);
    return Scaffold(
      appBar: AppBar(title: Text("My Events Page")),
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "DATE",
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectedDate();
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Event>>(
              stream: _getMyEvents(userProvider.getUser.uid),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 60,
                      height: 60,
                      child:
                          CircularProgressIndicator(), // Show a loading spinner while waiting.,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // show error message if any error occurred
                } else {
                  return CustomScrollView(
                    primary: false,
                    slivers: <Widget>[
                      SliverPadding(
                        padding: const EdgeInsets.all(20),
                        sliver: SliverGrid.count(
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 1,
                          // children: <Widget>[
                          //   ...snapshot.data!
                          //       .where(
                          //           (e) => isSameDate(e.eventDate, currentDate))
                          //       .map((event) {
                          //     return EventCard(
                          //       event: event,
                          //       addToFavourites: () => {},
                          //       isInFavourites: true,
                          //     );
                          //   }).toList(),
                          //   SizedBox(
                          //     height: 30,
                          //   ),
                          //   SizedBox(
                          //     height: 30,
                          //   ),
                          // ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> scheduleNotificationTomorrow(userId) async {
    Stream<List<Event>> favouriteEventsStream =
        FireStoreMethods().getFavouriteEvents(userId);

    favouriteEventsStream.listen((List<Event> favouriteEvents) async {
      // This code will be executed every time the favourite events for the user change in Firestore
      for (var event in favouriteEvents) {
        if (isEventDateTomorrow(event.eventDate)) {
          bool isNotificationScheduled =
              await NotificationApi.isNotificationScheduled(event.eventId);

          if (!isNotificationScheduled) {
            scheduleNewNotification(event);
          }
        }
      }
    });
  }

  bool isEventDateTomorrow(DateTime eventDate) {
    DateTime tomorrow = DateTime.now().add(Duration(days: 1));
    return eventDate.year == tomorrow.year &&
        eventDate.month == tomorrow.month &&
        eventDate.day == tomorrow.day;
  }

  Future<void> scheduleNewNotification(Event event) async {
    await NotificationApi.myNotifyScheduleInHours(
        title: event.title,
        msg: event.description,
        eventId: event.eventId,
        secondFromNow: 10,
        repeatNotif: false);
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Stream<List<Event>> _getMyEvents(userId) {
    return FireStoreMethods().getFavouriteEvents(userId);
  }

  Future<void> _selectedDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
        currentDate = _picked;
        // _filteredEvents = filterDates(_picked);
      });
    }
  }
}
