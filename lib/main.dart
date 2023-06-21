import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/notifier/select_company_notifier.dart';
import 'package:remark_app/pages/auth/login.dart';
import 'package:remark_app/pages/auth/mobile_validate.dart';
import 'package:remark_app/pages/auth/otp_validate.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:remark_app/pages/profile/complete_your_profile.dart';
import 'package:remark_app/pages/splashscreen/splashscreen.dart';
import 'config/appSetting.dart';
import 'notifier/interview_calling_notifier.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.max,
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  // FirebaseMessaging.instance.getToken();

  print('Handling a background message s ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance
      .requestPermission(
    alert: true,
  )
      .then((notice) async {
    await FirebaseMessaging.instance;
    await FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SelectCompanyNotifier(),
        ),
        ChangeNotifierProvider(
          create: (_) => InterviewCallingNotifier(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var subs;
  AppUpdateInfo _updateInfo;

  @override
  void initState() {
    // TODO: implement initState
    GetStorage.init();
    showForegroundNotification();
    checkForUpdate();
    getDynamicLinks();
    subs = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        SnackBar snackBar = SnackBar(content: Text("You are offline"));
      }
    });
    super.initState();
  }

  Future<void> checkForUpdate() {
    if (Platform.isAndroid) {
      InAppUpdate.checkForUpdate().then((updateInfo) {
        if (updateInfo.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          if (updateInfo.flexibleUpdateAllowed) {
            InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
              if (appUpdateResult == AppUpdateResult.success) {
                InAppUpdate.completeFlexibleUpdate();
              }
            });
          } else if (updateInfo.immediateUpdateAllowed) {
            InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
              if (appUpdateResult == AppUpdateResult.success) {
                print('App Updated');
              }
            });
          }
        } else {
          print("No update Available");
        }
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  getDynamicLinks() async {
    await AppSetting().getDynamicLinks(context);
  }

  showForegroundNotification() async {
    FirebaseMessaging _firebase = FirebaseMessaging.instance;
    await _firebase.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) async {
      await AppSetting().receiveNotification(message);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

// dfd
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remark',
      theme: ThemeData(primaryColor: kDarkColor),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScr(),
        '/login': (context) => Login(),
        '/mobile_validate': (context) => MobileValidate(),
        '/otp_validation': (context) => OtpValidate(),
        '/homepage/:userType': (context) => HomePage(),
        '/completeProfile': (context) => CompleteProfile(),
      },
    );
  }
}
