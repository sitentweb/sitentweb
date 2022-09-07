import 'dart:async';
import 'dart:convert';

import 'package:code_fields/code_fields.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:remark_app/apis/sms_gateway/send_sms.dart';
import 'package:remark_app/apis/user/UserApi.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:remark_app/model/auth/userDataModel.dart';
// import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class OtpValidate extends StatefulWidget {
  const OtpValidate({Key key}) : super(key: key);

  @override
  _OtpValidateState createState() => _OtpValidateState();
}

class _OtpValidateState extends State<OtpValidate> {
  Timer _timer;
  int _start = 59;
  bool showResend = false;
  CodeFieldsController _otp = new CodeFieldsController();
  TextEditingController _otpInput = new TextEditingController();
  String _validateOTP = "";
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String signature = "";
  bool verifying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_start == 0) {
        setState(() {
          showResend = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });

        print(_start);
      }
    });

    print(_start);
  }

  resendOTP() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var otp = AppSetting.randomOTPGenerator();
    pref.setInt('otp', otp);

    var mobileNumber = pref.getString("userMobile");

    await SendSMS().sendNewSms(mobileNumber, otp.toString(), '');

    setState(() {
      _start = 59;
      showResend = false;
    });

    _otp.clearCode();

    startTimer();
  }

  validateOTP() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var StoredOTP = pref.getInt('otp');
    if (_validateOTP == StoredOTP.toString() && _start != 0) {
      print('correct otp');

      var _token = await _firebaseMessaging.getToken();
      var _mobile = pref.getString('userMobile');
      print(_token);

      var userResp =
          await UserApi().getUserByMobileNumber(_mobile.toString(), _token);
      UserDataModel user = userResp;

      print(user.data.userType);
      print(user.data.userOrganization);

      UserSetting.setUserSession(user);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(userType: user.data.userType)));
    } else {
      print('incorrect otp');

      setState(() {
        verifying = false;
      });

      final snackBarMessage = SnackBar(
        content: Text("Invalid OTP"),
      );

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(snackBarMessage);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: size.width,
                  height: size.height * 0.8,
                  decoration: BoxDecoration(color: kDarkColor),
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: size.width,
                    height: size.height * 0.3,
                    child: Center(
                      child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Image.asset(
                              application_logo,
                              width: 80,
                            ),
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 200),
                  width: size.width,
                  height: size.height * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: size.width,
                        height: size.height * 0.1,
                        child: Center(
                          child: Text(
                            "Enter OTP",
                            style: GoogleFonts.poppins(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        width: size.width,
                        child: Center(
                          child: Text(
                            "Enter the correct otp we have sent on your mobile number",
                            style: GoogleFonts.poppins(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      // Container(
                      //   padding:
                      //       EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      //   child: CodeFields(
                      //     controller: _otp,
                      //     length: 4,
                      //     autofocus: true,
                      //     keyboardType: TextInputType.number,
                      //     inputDecoration: InputDecoration(
                      //       fillColor: kLightColor,
                      //       filled: true,
                      //       border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(20),
                      //           borderSide: BorderSide.none),
                      //       enabledBorder: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(20),
                      //           borderSide: BorderSide.none),
                      //     ),
                      //     closeOnFinish: true,
                      //     textStyle:
                      //         TextStyle(color: Colors.white, fontSize: 20),
                      //     onChanged: (code) {
                      //       print(code);
                      //     },
                      //     onCompleted: (code) {
                      //       setState(() {
                      //         _validateOTP = code;
                      //       });
                      //     },
                      //   ),
                      // ),
                      Container(
                        child: Pinput(
                          autofocus: true,
                          controller: _otpInput,
                          onCompleted: (code) {
                            setState(() {
                              _validateOTP = code;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        child: Row(
                          children: [
                            Text("00:${_start.toString().padLeft(2, '0')}",
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kDarkColor)),
                            Spacer(),
                            showResend
                                ? InkWell(
                                    onTap: () {
                                      print("Resend OTP");
                                      resendOTP();
                                    },
                                    child: Text("Resend OTP",
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kDarkColor)),
                                  )
                                : Text("Resend OTP",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: kLightColor.withOpacity(0.3)))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() {
                              verifying = true;
                            });
                            validateOTP();

                            // Navigator.pushReplacementNamed(context, '/homepage')
                          },
                          child: !verifying
                              ? Container(
                                  width: size.width * 0.8,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: kDarkColor,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 8)
                                      ]),
                                  child: Center(
                                      child: Text(
                                    "Verify",
                                    style: TextStyle(color: Colors.white),
                                  )))
                              : CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Terms & Condition",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkColor)),
                          SizedBox(
                            width: 10,
                          ),
                          Text("|",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkColor)),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Privacy Policy",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkColor))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
