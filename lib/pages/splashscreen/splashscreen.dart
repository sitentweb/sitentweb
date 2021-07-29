import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remark_app/pages/auth/login.dart';
import 'package:remark_app/pages/auth/mobile_validate.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:remark_app/pages/onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';

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
    checkInternetConnectivity();
    connectivityListening();
    super.initState();
  }

  checkInternetConnectivity() async {
    ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult == ConnectivityResult.none){
      var snackBar = SnackBar(content: Text("Mobile Network is disabled"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      print("Connected with internet");
    }
  }


  connectivityListening() async {
    subs = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      var snackBar;
      if(result == ConnectivityResult.none){
        snackBar = SnackBar(content: Row(
          children: [
            Icon(Icons.signal_cellular_connected_no_internet_4_bar , color: Colors.white,),
            SizedBox(width: 5,),
            Text("You are offline" , style: GoogleFonts.poppins(
                color: Colors.white
            ),)
          ],
        ));
      }else{
        snackBar = SnackBar(content: Row(
          children: [
            Icon(Icons.signal_cellular_4_bar_outlined , color: Colors.green,),
            SizedBox(width: 5,),
            Text("You are online" , style: GoogleFonts.poppins(
                color: Colors.green
            ), )
          ],
        ));
      }

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
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
    subs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body : Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          children: [
            Expanded(
              flex: 6,
              child: SplashScreen.callback(
                  name: 'assets/splash/splash_rive.riv',
                  startAnimation: 'Animation 1',
                  onSuccess: (data) {
                    setState(() {
                      _isLoading = !_isLoading;
                    });
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => userIsLogged ? userLogStep == "full" ? HomePage(userType: userType) : MobileValidate()  : onBoard ? Login() : OnBoardingScr()));
                  },
                  until: () => Future.delayed(Duration(milliseconds: 500)),
                  onError: (error, stacktrace) {
                    print(error);
                    print(stacktrace);
                  },
              ),
            ),
            Expanded(
              child: Container(
                child: !_isLoading ? Text("Loading..." , style: GoogleFonts.poppins()) : Text(""),
              ),
            )
          ],
        )
      ),
    );
  }
}
