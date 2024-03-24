import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dream_home/global/auth_details.dart';
import 'package:dream_home/global/utility.dart';
import 'package:dream_home/global/notification_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_home/global/ui_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dream_home/global/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

FirebaseOptions firebaseOptions = const FirebaseOptions(
  apiKey: "AIzaSyB8DYwOx8nMuwE4qFz4r-3zTJFQq43BBJs",
  appId: "1:499920943385:android:c117f502c1513320d8ad88",
  messagingSenderId: "499920943385",
  projectId: "dream-home-b052a",
  storageBucket: "dream-home-b052a.appspot.com",
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandle);

  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      showNetworkErrorDialog();
    }
  });

  Get.put(AuthController());

  runApp(GetMaterialApp(
    title: "DreamHome",
    getPages: appRoutes,
    initialRoute: "/",
    themeMode: ThemeMode.light,
    theme: MyThemes.light,
    darkTheme: MyThemes.dark,
    debugShowCheckedModeBanner: false,
  ));

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
  ));

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandle(RemoteMessage message) async {
  await Firebase.initializeApp(options: firebaseOptions);

  if (kDebugMode) {
    print("notification title ..... ${message.notification!.title}");
    print("notification body ..... ${message.notification!.body}");
    print("notification data ..... ${message.data}");
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final NotificationServices notificationServices = NotificationServices();

    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) async {
      Utils.tokenID = value;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("all_user_token")
          .where("TokenID", isEqualTo: Utils.tokenID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await FirebaseFirestore.instance
            .collection("all_user_token")
            .add({"TokenID": Utils.tokenID});

        if (kDebugMode) {
          print("Device token ..... ${Utils.tokenID}");
        }
      } else {
        if (kDebugMode) {
          print("Device token already exists ..... ${Utils.tokenID}");
        }
      }
    });
  }

  Future<void> checkedFirstTime() async {
    FirebaseFirestore.instance
        .collection("admin_login_info")
        .get()
        .then((QuerySnapshot snapshot) {
      for (var data in snapshot.docs) {
        Utils.adminPhone = data["Phone"];
        Utils.adminEmail = data["Email"];
      }
    });

    Utils.userPref = await SharedPreferences.getInstance();

    bool check = Utils.userPref!.getBool("check1") ?? false;

    if (check) {
      Get.offNamed("/splash");
    } else {
      await Utils.userPref!.setBool("check1", true);

      Get.offNamed("/onboarding");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkedFirstTime(),
        builder: (context, snapshot) {
          return Center(
            child: SizedBox(
              height: 35.0,
              width: 35.0,
              child: CircularProgressIndicator(
                color: MyColors.green3,
                strokeWidth: 1.8,
              ),
            ),
          );
        },
      ),
    );
  }
}
