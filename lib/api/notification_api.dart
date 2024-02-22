import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationApi {
  // Add your methods here
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {}

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {}

  @pragma("vm:entry-point")
  static Future<void> onActionRecievedMethod(
      ReceivedAction receivedAction) async {}

  static Future<void> myNotifyScheduleInHours({
    required int secondFromNow,
    required String title,
    required String msg,
    required String eventId,
    bool repeatNotif = false,
  }) async {
    var nowDate = DateTime.now().add(Duration(seconds: secondFromNow));
    await AwesomeNotifications().createNotification(
      schedule: NotificationCalendar(
        //weekday: nowDate.day,
        hour: nowDate.hour,
        minute: nowDate.minute,
        second: nowDate.second,
        repeats: repeatNotif,
        //allowWhileIdle: true,
      ),
      content: NotificationContent(
        id: -1,
        channelKey: 'channel_events',
        title: 'You have the event $title tomorrow! Better get ready :)',
        body: '$msg',
        notificationLayout: NotificationLayout.BigPicture,
        //actionType : ActionType.DismissAction,
        color: Colors.black,
        backgroundColor: Colors.black,
        // customSound: 'resource://raw/notif',
        payload: {'eventId': eventId},
      ),
    );
  }

  static Future<bool> isNotificationScheduled(String eventId) async {
    List<NotificationModel> scheduledNotifications =
        await AwesomeNotifications().listScheduledNotifications();
    for (var notification in scheduledNotifications) {
      if (notification.content!.payload!.containsKey('eventId')) {
        String scheduledEventId =
            notification.content!.payload!['eventId'] as String;
        if (scheduledEventId == eventId) {
          return true;
        }
      }
    }
    return false;
  }
}
