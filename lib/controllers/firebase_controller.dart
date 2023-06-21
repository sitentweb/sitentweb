import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FirebaseController extends GetxController {
  RxString generatedToken = ''.obs;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  generateToken() async {
    var token = await firebaseMessaging.getToken();

    generatedToken(token);
    generatedToken.refresh();
  }
}
