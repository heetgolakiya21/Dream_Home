import 'dart:io';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User Granted notification permission ...");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User Granted Provisional notification permission ...");
      }
    } else {
      AppSettings.openAppSettings();
      if (kDebugMode) {
        print("User Denied notification permission ...");
      }
    }
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSetting =
        InitializationSettings(android: androidInitialization);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) async {
      handleRequest(context, message);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data["type"]);
      }

      if (Platform.isAndroid) {
        initLocalNotification(context, message);

        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      // "101",
      "Max Importance",
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "Your channel description",
      importance: Importance.high,
      ticker: "Notification ticker",
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      ongoing: false,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([1000, 500, 1000]),
      category: AndroidNotificationCategory.message,
      // fullScreenIntent: true,
      // actions: [
      //   const AndroidNotificationAction("V1", "View request"),
      //   const AndroidNotificationAction(
      //     'R1',
      //     'Dismiss',
      //     cancelNotification: true,
      //   ),
      // ],
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      if (kDebugMode) {
        print("Token refreshed .....");
      }
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    //when app is terminated ..
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // handleRequest(context, initialMessage);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // handleRequest(context, message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // handleRequest(context, message);
    });
  }

  void handleRequest(BuildContext context, RemoteMessage message) {
    if (message.data["type"] == "alert") {
      Get.dialog(
        barrierDismissible: false,
        Center(
          child: Wrap(
            children: [
              AlertDialog(
                backgroundColor: MyColors.white0,
                title: Text(
                  message.notification!.title.toString(),
                  style: TextStyle(
                    fontFamily: "nunito",
                    fontSize: 20.0,
                    color: MyColors.green2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: MyColors.black0,
                        fontFamily: "nunito",
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.notification!.body.toString(),
                      style: TextStyle(
                        color: MyColors.black0,
                        fontFamily: "nunito",
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      message.data["description"],
                      style: TextStyle(
                        color: MyColors.black0,
                        fontFamily: "nunito",
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
