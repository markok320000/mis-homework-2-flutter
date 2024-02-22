import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_scheduler_project/models/eventMode.dart';
import 'package:event_scheduler_project/providers/user_provider.dart';
import 'package:event_scheduler_project/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadEvent(
      String description,
      Uint8List file,
      String userid,
      GeoPoint location,
      String title,
      DateTime eventDate,
      TimeOfDay eventTime) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('events', file, true);
      String eventId = const Uuid().v1(); // creates unique id based on time
      Event event = Event(
          location: location,
          title: title,
          userId: userid,
          eventId: eventId,
          eventDate: eventDate,
          photoUrl: photoUrl,
          description: description,
          eventTime: eventTime);
      _firestore.collection('events').doc(eventId).set(event.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> addToFavourites(String eventId, String userId) async {
    String res = "Some error occurred";
    try {
      _firestore.collection("users").doc(userId).update({
        'myEvents': FieldValue.arrayUnion([eventId])
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> removeFromFavourites(String eventId, String userId) async {
    String res = "Some error occurred";
    try {
      _firestore.collection("users").doc(userId).update({
        'myEvents': FieldValue.arrayRemove([eventId])
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<List<Event>> getEvents() async {
    QuerySnapshot querySnapshot = await _firestore.collection('events').get();
    List<Event> events =
        querySnapshot.docs.map((doc) => Event.fromSnap(doc)).toList();
    return events;
  }

  Stream<List<Event>> getFavouriteEvents(String userId) {
    return getFavouriteEventIds().transform(
      StreamTransformer.fromHandlers(
        handleData: (eventIds, sink) {
          _firestore
              .collection('events')
              .where(FieldPath.documentId,
                  whereIn: eventIds.isNotEmpty ? eventIds : List.empty())
              .snapshots()
              .map((snapshot) =>
                  snapshot.docs.map((doc) => Event.fromSnap(doc)).toList())
              .listen(sink.add);
        },
      ),
    );
  }

  Stream<List<String>> getFavouriteEventIds() {
    String userId = FirebaseAuth.instance.currentUser!.uid.toString();
    return _firestore.collection('users').doc(userId).snapshots().map(
        (snapshot) => List<String>.from(snapshot.data()?['myEvents'] ?? []));
  }

  Future<Event> fetchEventById(String id) async {
    DocumentSnapshot doc = await _firestore.collection('events').doc(id).get();
    if (doc.exists) {
      return Event.fromSnap(doc);
    } else {
      throw Exception('Event not found');
    }
  }
}
