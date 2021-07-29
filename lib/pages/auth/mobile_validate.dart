import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_number_picker/mobile_number_picker.dart';
import 'package:remark_app/apis/auth/login.dart';
import 'package:remark_app/apis/sms_gateway/send_sms.dart';
import 'package:remark_app/components/snackbar_alerts/icon_text.dart';
import 'package:remark_app/config/appSetting.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/auth/loginModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileValidate extends StatefulWidget {
  const MobileValidate({Key key}) : super(key: key);

  @override
  _MobileValidateState createState() => _MobileValidateState();
}

class _MobileValidateState extends State<MobileValidate> {
  bool isLoading = false;
  MobileNumberPicker mobileNumber = MobileNumberPicker();
  MobileNumber mobileNumberObject = MobileNumber();
  String userMobile = "";
  TextEditingController _mobileNumber = TextEditingController();

  validateMobileNumber(String mobileNumber) {
    if (mobileNumber.length != 10) {
      return false;
    } else {
      return true;
    }
  }

  randomOTPGenerator() {
    Random otp = new Random();
    var otpGen = 1000 + otp.nextInt(9999 - 1000);
    return otpGen;
  }

  @override
  void initState() {
    // TODO: implement initState

    getUserCredential();
    super.initState();
  }

  getUserCredential() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (pref.get("userMobile") != null) {
      print(pref.get("userMobile"));
      if (pref.getString("userMobile") != "") {
        _mobileNumber.text = pref.getString("userMobile");
      }
    } else {
      askAboutMobileNumber();
    }
  }

  askAboutMobileNumber() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await mobileNumber.mobileNumber();
      print(timeStamp);
    });

    mobileNumber.getMobileNumberStream.listen((event) {
      if (event?.states == PhoneNumberStates.PhoneNumberSelected) {
        setState(() {
          mobileNumberObject = event;
          _mobileNumber.text = mobileNumberObject.phoneNumber;
          print(mobileNumberObject.phoneNumber);
        });
      } else {
        final snackBar = SnackBar(
            content: IconSnackBar(
          iconData: Icons.warning_amber_outlined,
          textData: "Mobile Number not detected",
          textColor: Colors.white,
        ));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    mobileNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                      "Enter Phone Number",
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
                      "We will send you OTP on this mobile number to verify your identity",
                      style: GoogleFonts.poppins(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: _mobileNumber,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.poppins(fontSize: 20),
                            autofocus: true,
                            decoration: InputDecoration(
                              prefix: Container(
                                width: size.width * 0.22,
                                child: Row(
                                  children: [
                                    Text("  +91 " , style: GoogleFonts.poppins(),),
                                    Container(
                                      height: 25,
                                      child: VerticalDivider(
                                        color: kDarkColor,
                                        thickness: 2,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              hintText: '1234567890',
                              hintStyle: GoogleFonts.poppins(fontSize: 20),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                !isLoading
                    ? GestureDetector(
                        onTap: () async {
                          var otp = AppSetting.randomOTPGenerator();
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setInt('otp', otp);
                          if (validateMobileNumber(_mobileNumber.text)) {
                            setState(() {
                              isLoading = true;
                            });
                            // Toast.show("Your Generated OTP is ${otp.toString()}", context, duration: Toast.LENGTH_LONG , gravity:  Toast.BOTTOM);
                            final snackbarotp = SnackBar(
                              content: Text("Your OTP is ${otp.toString()}" , style: GoogleFonts.poppins(),),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackbarotp);

                            await SendSMS().sendNewSms();

                            LoginApiModel loginResp = await LoginApi()
                                .loginApi(_mobileNumber.text, otp.toString());
                            if (loginResp.status) {
                              pref.setString('userMobile', _mobileNumber.text);
                              Navigator.pushNamed(context, '/otp_validation');
                            }
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            final snackBar = SnackBar(
                              content: IconSnackBar(
                                iconData: Icons.dangerous,
                                textData: "Invalid Mobile Number",
                                textColor: Colors.red,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          // Navigator.pushNamed(context, '/otp_validation');
                        },
                        child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: kDarkColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8)
                                ]),
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            )),
                      )
                    : Container(
                        padding: EdgeInsets.all(10),
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
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          backgroundColor: kLightColor,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileNumberUI extends StatefulWidget {
  const MobileNumberUI({Key key}) : super(key: key);

  @override
  _MobileNumberUIState createState() => _MobileNumberUIState();
}

class _MobileNumberUIState extends State<MobileNumberUI> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width,
          height: size.height * 0.2,
          child: Center(
            child: Icon(FontAwesomeIcons.mobile),
          ),
        ),
        Container(),
        Container(),
        Container()
      ],
    );
  }
}
