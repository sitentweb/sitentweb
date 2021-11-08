import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/main.dart';

class AppSetting {

  Future<bool> askForStoragePermission() async {
      bool permissionGranded = false;

      var storagePermission = Permission.storage;
      var extStoragePermission = Permission.manageExternalStorage;
      var mediaAccessPermission = Permission.accessMediaLocation;

      if(await storagePermission.status.isDenied){

          // if storage permission is denied then ask for new permission;
          if(await storagePermission.request().isGranted){
             permissionGranded = await storagePermission.status.isGranted;
          }else{
            permissionGranded = await storagePermission.status.isDenied;
          }

          permissionGranded = await storagePermission.status.isDenied;

      }else{

          if(await extStoragePermission.status.isDenied){
            if(await extStoragePermission.request().isGranted){
              permissionGranded = await extStoragePermission.status.isGranted;
            }else{
              permissionGranded = await extStoragePermission.status.isDenied;
            }
          }else{
            permissionGranded = await extStoragePermission.status.isGranted;
          }

          permissionGranded = await storagePermission.status.isGranted;

      }

      return permissionGranded;

  }


  Future<bool> createAppFolder() async {
    bool isPathAvailable = false;

     final path = Directory("/storage/emulated/0/Remark");
     final resumePath = Directory("/storage/emulated/0/Remark/resumes");

     if(await path.exists()){
       isPathAvailable = true;
     }else{
       if(await askForStoragePermission()){
         path.create();
         resumePath.create();
         isPathAvailable = true;
       }else{
         print("Can't create folder");
         isPathAvailable = false;
       }
     }

     return isPathAvailable;
  }

  Future<bool> createResumeFolder() async {

  }

  Future receiveNotification(RemoteMessage message) async {
    print('notification listening started ${message.data}');

    showNotification(message);

  }

  showNotification(RemoteMessage message) async {

    var initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    RemoteNotification notification = message.notification;

    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null) {

      await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              setAsGroupSummary: true,
              fullScreenIntent: true,
              importance: Importance.max,
              icon: android?.smallIcon,
            ),
          ));
    }
  }

  Future receiveChatMessage(RemoteMessage message) async {

    RemoteNotification notification = message.notification;

    AndroidNotification android = message.notification?.android;
    if (notification != null && android != null) {
      return message.data;
    }

    return message;

  }

  static showUserImage(String image){
     if(image != null || image != ""){
       return NetworkImage(image);
     }else{
       return AssetImage(application_logo);
     }
  }

  static randomOTPGenerator() {
    Random otp = new Random();
    var otpGen = 1000 + otp.nextInt(9999 - 1000);
    return otpGen;
  }

  static Size size(BuildContext context) {
      Size size;
      size = MediaQuery.of(context).size;
      return size;
  }

  static Widget sizedBox(double width , double height) {
      return SizedBox(
        width: width,
        height: height
      );
  }

}