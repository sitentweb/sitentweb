import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/components/buttons/login_button.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/pages/auth/mobile_validate.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  UserCredential user;
  bool userIsLogged = false;
  String userType = '0';


  @override
  void initState() {
    // TODO: implement initState
    checkLoginStatus();
    super.initState();

  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    // await GoogleSignIn().disconnect();
    var logg = "";

    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    logg = googleUser.displayName;

    if(googleUser != null){
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;


      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserSetting.setGoogleSignInSession(credential);

      // Once signed in, return the UserCredential
      // return await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MobileValidate(),));
    }else{
      print("google user is null");
    }





  }

  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.get('userIsLogged') != null){
      if(prefs.getBool('userIsLogged')){

        if(prefs.getString("userLogStep") == "full"){
          userType = prefs.getString('userType');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(userType: userType,),));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MobileValidate(),));
        }


      }
    }

  }




  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  width: _size.width,
                  child: Center(
                    child: Image.asset(application_logo , width: 150,),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: 30),
                  alignment: Alignment.topCenter,
                  width: _size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        LoginButton(
                          icon: Icons.login,
                          title: 'Employee or Employer',
                          color: kDarkColor,
                          actionOnClick: () => showMaterialModalBottomSheet(
                              expand: false,
                              context: context,
                              builder: (context) => MobileValidate()
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        LoginButton(
                          icon: FontAwesomeIcons.google,
                          title: 'Login with Google',
                          color: Colors.redAccent,
                          actionOnClick: () {
                              signInWithGoogle();
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
