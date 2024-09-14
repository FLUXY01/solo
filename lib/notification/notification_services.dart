import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:global_chat_app/pages/chat_page.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings notificationSettings =
    await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      announcement: true,
      provisional: true,
      sound: true,
    );
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print("Permission Granted");
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("Provisional Permission Granted");
    } else {
      print("Permission not granted ");
    }
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void firebaseMessageInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      initLocalNotification(context, message);
      showNotification(message);
    });
  }

  void initLocalNotification(BuildContext context,
      RemoteMessage remoteMessage) async {
    var androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/ic_launcher");
    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessages(context, remoteMessage);
      },
    );
  }

  Future<void> showNotification(RemoteMessage remoteMessage) async {
    AndroidNotificationChannel androidNotificationChannel =
    const AndroidNotificationChannel(
      "101",
      "High Immportance Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      channelDescription: "My channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
    );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        0, remoteMessage.notification!.title.toString(),
        remoteMessage.notification!.body.toString(), notificationDetails,
      );
    });
  }

  Future<void> setupInteractMessages(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      handleMessages(context, initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event){
      handleMessages(context, event);
    });

  }

  void handleMessages(BuildContext context, RemoteMessage remoteMessage) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    if (remoteMessage.data["receiverId"] != firebaseAuth.currentUser!.uid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
        receiverUserEmail: remoteMessage.data["receiverId"],
        receiverUserID: remoteMessage.data["receiverEmail"]),
      ),
    );
  }
  }
}
