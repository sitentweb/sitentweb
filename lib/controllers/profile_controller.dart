import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remark_app/apis/user/UserApi.dart';

class ProfileController extends GetxController {
  TextEditingController userName = TextEditingController();
  TextEditingController userBio = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userMobile = TextEditingController();

  updateMobileNumber(mobileNumber) async {
    final res = await UserApi().startVerifyMobileNumber(mobileNumber);

    if (res.status) {}
  }
}
