import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:remark_app/apis/auth/login.dart';
import 'package:remark_app/components/buttons/login_button.dart';
import 'package:remark_app/components/loading/circular_loading.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/config/pageSetting.dart';
import 'package:remark_app/config/userSetting.dart';
import 'package:remark_app/controllers/auth_controller.dart';
import 'package:remark_app/model/auth/loginEmailModel.dart';
import 'package:remark_app/model/auth/rakshModel.dart';
import 'package:remark_app/model/auth/userDataModel.dart';
import 'package:remark_app/model/global/global_model.dart';
import 'package:remark_app/pages/auth/mobile_validate.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthController authController = Get.put(AuthController());
  bool isSignIn = false;
  UserCredential user;
  bool userIsLogged = false;
  String userType = '0';
  final storage = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    checkLoginStatus();
    super.initState();
  }

  Future<UserCredential> signInWithApple() async {
    final firebsaeAuth = FirebaseAuth.instance;

    final rawNonce = generateNonce();

    final nonce = sha256ofString(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName
    ], nonce: nonce);

    if (credential == null) {
      print('Not able to login');
    } else {
      print(credential.authorizationCode);
      final oauth = OAuthProvider("apple.com")
          .credential(idToken: credential.identityToken, rawNonce: rawNonce);

      final authResult = await firebsaeAuth.signInWithCredential(oauth);

      print(authResult.user.email);

      // LOGIN WITH EMAIL
      LoginEmail res =
          await LoginApi().loginWithEmail(authResult.user.email, 'Apple');

      if (res.status) {
        print(res.data.user.toJson().toString());
        // UserSetting.setAppleSignInSession(oauth);
        UserDataModel userModel = UserDataModel.fromJson(
            {"status": true, "data": res.data.user.toJson()});

        UserSetting.setUserSession(userModel);
      }

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userType: res.data.user.userType,
            ),
          ));
      // return authResult.user;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    // await GoogleSignIn().disconnect();
    var logg = "";

    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }

    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    logg = googleUser.displayName;

    print(logg);

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = await GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // LOGIN WITH EMAIL

      final resp =
          await LoginApi().loginWithEmail(authResult.user.email, 'Google');

      GlobalModel res = await LoginApi().login({
        "mobile_number": "",
        "email_address": authResult.user.email,
        "login_type": "email"
      });

      if (res.status) {
        RakshModel rakshModel = res.data;

        // UserSetting.setAppleSignInSession(oauth);
        UserDataModel userModel = UserDataModel.fromJson(
            {"status": true, "data": resp.data.user.toJson()});

        authController.setJwtToken(rakshModel.token);
        UserSetting.setUserSession(userModel);

        Get.off(() => HomePage(userType: rakshModel.userType));
      } else {
        RemarkPageSetting.showSnackbar(
            title: 'Login Failed', message: res.message);
      }
    } else {
      print("google user is null");
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.get('userIsLogged') != null) {
      if (prefs.getBool('userIsLogged')) {
        if (prefs.getString("userLogStep") == "full") {
          userType = prefs.getString('userType');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  userType: userType,
                ),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MobileValidate(),
              ));
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
            flex: 1,
            child: Container(
              width: _size.width,
              child: Center(
                child: Image.asset(
                  application_logo,
                  width: 150,
                ),
              ),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(top: 20),
              alignment: Alignment.bottomCenter,
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
                          builder: (context) => MobileValidate()),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // if (Theme.of(context).platform == TargetPlatform.iOS)
                    !isSignIn
                        ? LoginButton(
                            icon: Icons.login,
                            title: 'Sign In with Google',
                            color: Colors.redAccent,
                            actionOnClick: () async {
                              await signInWithGoogle();
                            },
                          )
                        : CircularLoading(),
                    if (Theme.of(context).platform == TargetPlatform.iOS)
                      SizedBox(
                        height: 15,
                      ),
                    if (Theme.of(context).platform == TargetPlatform.iOS)
                      // SignInWithAppleButton(onPressed: () async {
                      //   final credential =
                      //       await SignInWithApple.getAppleIDCredential(scopes: [
                      //     AppleIDAuthorizationScopes.email,
                      //     AppleIDAuthorizationScopes.fullName
                      //   ]);
                      // })
                      !isSignIn
                          ? LoginButton(
                              icon: Icons.apple,
                              title: 'Sign In with Apple',
                              color: Colors.black87,
                              actionOnClick: () async {
                                await signInWithApple();
                              })
                          : CircularLoading(),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(
          //   height: 5,
          // ),
          // Divider(),
          // GestureDetector(
          //   onTap: () {
          //     Get.to(() => HomePage(
          //           userType: "0",
          //         ));
          //   },
          //   child: Text(
          //     "Skip >",
          //     style: TextStyle(
          //         color: kDarkColor, decoration: TextDecoration.underline),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text:
                        "By creating an account or loggin in , you are agree to the"),
                TextSpan(
                    text: "Terms & Privacy",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: kDarkColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        var url = 'https://remarkhr.com/privacy-policy';
                        await canLaunchUrl(Uri.parse(url))
                            ? launchUrl(Uri.parse(url))
                            : print("Can't launch url");
                        print("Terms & Condition");
                      })
              ]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ));
  }
}
