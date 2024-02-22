import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String uid;
  List myEvents;

  User({required this.email, required this.uid, required this.myEvents});

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      email: snapshot["email"],
      uid: snapshot["uid"],
      myEvents: snapshot["myEvents"],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
        "myEvents": myEvents,
      };
}
