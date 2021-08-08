import 'dart:convert';

import 'package:code_fields/code_fields.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/apis/user/UserApi.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:remark_app/model/auth/userDataModel.dart';

class OtpValidate extends StatefulWidget {
  const OtpValidate({Key key}) : super(key: key);

  @override
  _OtpValidateState createState() => _OtpValidateState();
}

class _OtpValidateState extends State<OtpValidate> {
  CodeFieldsController _otp = new CodeFieldsController();
  String _validateOTP = "";
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  width: size.width,
                  height: size.height * 0.3,
                  child: Center(
                    child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                            color: kDarkColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: Icon(
                          FontAwesomeIcons.mobile,
                          color: Colors.white,
                        )),
                  ),
                ),
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
                      style: GoogleFonts.poppins(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: CodeFields(
                    controller: _otp,
                    length: 4,
                    autofocus: true,
                    inputDecoration: InputDecoration(
                      fillColor: kLightColor,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none),
                    ),
                    closeOnFinish: true,
                    textStyle: TextStyle(color: Colors.white, fontSize: 20),
                    onChanged: (code) {
                      print(code);
                    },
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
                  child: GestureDetector(
                    onTap: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();

                      var StoredOTP = pref.getInt('otp');
                      if (_validateOTP == StoredOTP.toString()) {
                        print('correct otp');

                        var _token = await _firebaseMessaging.getToken();
                        var _mobile = pref.getString('userMobile');
                        print(_token);
                        
                        var userResp = await UserApi()
                            .getUserByMobileNumber(_mobile.toString(), _token);
                        UserDataModel user = userResp;

                        print(user.data.userType);
                        print(user.data.userOrganization);

                        UserSetting.setUserSession(user);

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(userType: user.data.userType)));
                      } else {
                        print('incorrect otp');
                        final snackBarMessage = SnackBar(
                          content: Text("Invalid OTP"),
                        );

                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBarMessage);
                      }

                      // Navigator.pushReplacementNamed(context, '/homepage')
                    },
                    child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: kDarkColor,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8)
                            ]),
                        child: Icon(
                          Icons.chevron_right,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
