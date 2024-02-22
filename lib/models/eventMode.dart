import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  final String eventId;
  final String userId;
  final GeoPoint location;
  final String title;
  final DateTime eventDate;
  final String description;
  final String photoUrl;
  final TimeOfDay eventTime;

  Event(
      {required this.location,
      required this.title,
      required this.photoUrl,
      required this.userId,
      required this.eventDate,
      required this.description,
      required this.eventId,
      required this.eventTime});

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
      eventId: snapshot["eventId"],
      userId: snapshot["userId"],
      location: snapshot["location"],
      title: snapshot["title"],
      photoUrl: snapshot['photoUrl'],
      eventDate: (snapshot["eventDate"] as Timestamp).toDate(),
      description: snapshot["description"],
      eventTime: TimeOfDay(
        hour: snapshot["eventTime"]["hour"],
        minute: snapshot["eventTime"]["minute"],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "eventId": eventId,
        "eventDate": eventDate,
        "description": description,
        "location": location,
        "title": title,
        "photoUrl": photoUrl,
        "eventTime": {
          "hour": eventTime.hour,
          "minute": eventTime.minute,
        },
      };

  LatLng geoLocationToLatLng() {
    return LatLng(location.latitude, location.longitude);
  }
}
