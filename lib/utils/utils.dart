import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:event_scheduler_project/resources/auth_methods.dart';
import 'package:event_scheduler_project/resources/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../models/eventMode.dart';
import '../models/user.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

// notifyNearByEvent(Position currentLocation, List<Event> eventsNotified) async {
//   User user = await AuthMethods().getUserDetails();

//   if (user.uid == "") {
//     return;
//   }

//   Stream<List<Event>> eventStream =
//       FireStoreMethods().getFavouriteEvents(user.uid);

//   eventStream.listen((List<Event> eventList) {
//     for (var event in eventList) {
//       // Process each event
//       double distanceInMeters = Geolocator.distanceBetween(
//           event.location.latitude,
//           event.location.longitude,
//           currentLocation.latitude,
//           currentLocation.longitude);

//       if (distanceInMeters < 1000) {
//         print("najden even");
//         if (eventsNotified.any((eve) => event.eventId == eve.eventId)) {
//           return;
//         }
//         AwesomeNotifications().createNotification(
//           content: NotificationContent(
//               id: 1,
//               channelKey: "channel_events",
//               title: "You have an event nearby",
//               body: "Check the events map, there is an event nearby"),
//         );
//         eventsNotified.add(event);
//       }
//     }
//   });
// }
