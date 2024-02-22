import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // create instance3 of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to init notif
  Future<void> initNotifications() async {
    //request permission from user
    await _firebaseMessaging.requestPermission();

    //fetch the FCM token for the device
    final fcMToken = await _firebaseMessaging.getToken();

    //print the token
    print('Token: $fcMToken');
  }

  //function to handle recieved message
  void handleMessage(RemoteMessage? message) {}

  //function to init foreground and background settings
}
