import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/pages/auth/login.dart';
import 'package:remark_app/pages/auth/mobile_validate.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:remark_app/pages/onboarding/onboarding.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScr extends StatefulWidget {
  const SplashScr({Key key}) : super(key: key);

  @override
  _SplashScrState createState() => _SplashScrState();
}

class _SplashScrState extends State<SplashScr> {
  bool _isLoading = true;
  bool userIsLogged = false;
  String userLogStep = "";
  bool onBoard = false;
  String userType;
  var subs;

  @override
  void initState() {
    // TODO: implement initState
    getUserLogged();
    super.initState();
  }

  Future getUserLogged() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    setState(() {
      userIsLogged = pref.getBool("userIsLogged") ?? false;
      userLogStep = pref.getString("userLogStep") ?? "";
      onBoard = pref.getBool("onboard") ?? false;
      userType = pref.getString("userType");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(left: 0),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Spacer(),
              Expanded(
                child: Center(
                  child: SplashScreen.callback(
                    name: 'assets/splash/splash_rive.riv',
                    startAnimation: 'Animation 1',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    onSuccess: (data) {
                      setState(() {
                        _isLoading = !_isLoading;
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => userIsLogged
                                  ? userLogStep == "full"
                                      ? HomePage(userType: userType)
                                      : MobileValidate()
                                  : onBoard
                                      ? Login()
                                      : OnBoardingScr()));
                    },
                    until: () => Future.delayed(Duration(milliseconds: 500)),
                    onError: (error, stacktrace) {
                      print(error);
                      print(stacktrace);
                    },
                  ),
                ),
              ),
              Spacer(),
            ],
          )),
    );
  }
}
