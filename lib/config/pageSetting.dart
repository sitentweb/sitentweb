import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemarkPageSetting {
  static SnackbarController showSnackbar({title, message}) {
    return Get.showSnackbar(GetSnackBar(
      title: title,
      message: message,
      snackStyle: SnackStyle.GROUNDED,
      duration: Duration(seconds: 2),
    ));
  }
}
