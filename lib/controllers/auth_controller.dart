import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:remark_app/apis/auth/login.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/model/auth/authModel.dart';
import 'package:remark_app/model/auth/rakshModel.dart';
import 'package:remark_app/pages/auth/otp_validate.dart';
import 'package:remark_app/pages/homepage/homepage.dart';

class AuthController extends GetxController {
  RxBool isLogged = false.obs;
  RxString loginType = 'mobile'.obs;
  Rx<TextEditingController> mobileNumber = TextEditingController().obs;
  RxBool isLoading = false.obs;
  Rx<TextEditingController> otp = TextEditingController().obs;
  RxString jwtToken = ''.obs;
  RxString emailAddress = ''.obs;
  RxBool isOTPVerified = false.obs;
  final storage = GetStorage();

  reVerifyOTP() async {}

  doLogin() async {
    isLoading(true);
    otp.value.text = '';
    final response = await LoginApi().login({
      "mobile_number": mobileNumber.value.text,
      "email_address": emailAddress.value,
      "login_type": loginType.value
    });

    if (response.status) {
      RakshModel rakshModel = response.data;
      setJwtToken(rakshModel.token);

      print(rakshModel.token);

      var snackbar = GetSnackBar(
        title: 'OTP Sent Successfully',
        message: response.message,
        backgroundColor: Colors.green,
        snackStyle: SnackStyle.GROUNDED,
        duration: Duration(seconds: 2),
      );

      Get.showSnackbar(snackbar);

      Get.to(() => OtpValidate());
    } else {
      var snackbar = GetSnackBar(
        title: 'Login Failed',
        message: response.message,
        backgroundColor: Colors.red,
        snackStyle: SnackStyle.GROUNDED,
        duration: Duration(seconds: 2),
      );

      Get.showSnackbar(snackbar);
    }

    isLoading(false);
  }

  setJwtToken(token) {
    storage.write('jwtToken', token);
    jwtToken(token);
    jwtToken.refresh();
  }

  Future<AuthModel> verifyOTP() async {
    isLoading(true);

    final res = await LoginApi().verifyOTP(otp.value.text, jwtToken.value);

    if (res.status) {
      isOTPVerified(true);
      AppSetting.showSnackbar(
          title: "Success",
          message: "OTP Verified Successfully",
          type: 'success');

      storage.write('jwtToken', jwtToken.value);

      return res;
    } else {
      isLoading(false);
      isOTPVerified(false);
      otp.value.text = '';
      AppSetting.showSnackbar(
          title: 'Failure', message: res.message, type: 'danger');

      return AuthModel(status: false);
    }
  }

  refreshAuth() {
    otp.value.text = '';
    otp.refresh();

    mobileNumber.value.text = '';
    mobileNumber.refresh();

    isLoading(false);

    jwtToken.value = '';
    jwtToken.refresh();
  }

  startTimer() {}

  doLoggedIn() {
    isLogged(true);
    isLogged.refresh();
  }

  doLogout() {
    isLogged(false);
    isLogged.refresh();
  }
}
