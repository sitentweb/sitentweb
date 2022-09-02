import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remark_app/apis/user/UserApi.dart';
import 'package:remark_app/config/constants.dart';
import 'package:remark_app/model/auth/userDataModel.dart';
import 'package:remark_app/model/user/fetch_user_data.dart';
import 'package:remark_app/pages/homepage/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSetting {
  Future userType(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("userType") == '0') {
      print('user is nothing');
      Navigator.pushReplacementNamed(context, '/completeProfile');
    } else if (pref.getString("userType") == '1') {
      print('user is employee');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userType: userType,
            ),
          ));
    } else {
      print('user is employer');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              userType: userType,
            ),
          ));
    }
  }

  static interviewType(interviewType) {
    var typeName;

    if (interviewType == 0) {
      typeName = "Voice Call";
    } else {
      typeName = "Video Call";
    }

    return typeName;
  }

  static userOrganizationType(organizationType) {
    var organizationTypeName;

    if (organizationType == "0") {
      organizationTypeName = "Company";
    } else {
      organizationTypeName = "Consultancy";
    }

    return organizationTypeName;
  }

  static setUserSession(UserDataModel user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (user.data.userType == "2") {
      pref.setString("userOrganization", user.data.userOrganization);
      pref.setString("userOrganizationType", user.data.userOrganizationType);
    } else if (user.data.userType == "1") {
      pref.setString('userUsername', user.data.userUsername ?? "");
      pref.setString('userJobLocation', user.data.userJobLocation ?? "");
      pref.setString('userExperience', user.data.userExperience ?? "");
      pref.setString('userSkills', user.data.userSkills ?? "");
      pref.setString('userLocation', user.data.userLocation ?? "");
      pref.setString("userQualifications", user.data.userQualifications ?? "");
      pref.setString('userLanguages', user.data.userLanguages ?? "");
      pref.setString('userResume', user.data.userResume ?? "");
    } else if (user.data.userType == "0") {
      print("New User is setting up");

      pref.setString('userUsername', "");
      pref.setString('userJobLocation', "");
      pref.setString('userExperience', "");
      pref.setString('userSkills', "");
      pref.setString('userLocation', "");
      pref.setString("userQualifications", "");
      pref.setString('userLanguages', "");
    }

    pref.setString('userID', user.data.userId ?? "");
    pref.setString('userToken', user.data.userToken ?? "");
    pref.setString('userType', user.data.userType ?? "");
    pref.setString('userBio', user.data.userBio ?? "");
    pref.setBool('userIsLogged', true);
    pref.setString("userLogStep", "full");

    if (pref.get("loginType") == null) {
      pref.setString("loginType", "normal");
    }

    if (pref.getString("loginType") == "normal") {
      pref.setString("userMobile", user.data.userMobile);
      pref.setString('userName', user.data.userName ?? "");
      pref.setString('userPhoto', user.data.userPhoto ?? "");
      pref.setString('userEmail', user.data.userEmail ?? "");
    } else {
      pref.setString("userMobile", user.data.userMobile);
      pref.setString(
          'userName',
          user.data.userName != ""
              ? user.data.userName
              : pref.getString("userName"));
      pref.setString(
          'userPhoto',
          user.data.userPhoto != ""
              ? user.data.userPhoto
              : pref.getString("userPhoto"));
      pref.setString(
          'userEmail',
          user.data.userEmail != ""
              ? user.data.userEmail
              : pref.getString("userEmail"));
    }
  }

  static setUserSessionData(FetchUserDataModel user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (user.data.userType == "2") {
      pref.setString("userOrganization", user.data.userOrganization);
      pref.setString("userOrganizationType", user.data.userOrganizationType);
    } else if (user.data.userType == "1") {
      pref.setString('userUsername', user.data.userUsername ?? "");
      pref.setString('userJobLocation', user.data.userJobLocation ?? "");
      pref.setString('userExperience', user.data.userExperience ?? "");
      pref.setString('userSkills', user.data.userSkills ?? "");
      pref.setString('userLocation', user.data.userLocation ?? "");
      pref.setString("userQualifications", user.data.userQualifications ?? "");
      pref.setString('userLanguages', user.data.userLanguages ?? "");
      pref.setString('userResume', user.data.userResume ?? "");
    } else if (user.data.userType == "0") {
      print("New User is setting up");

      pref.setString('userUsername', "");
      pref.setString('userJobLocation', "");
      pref.setString('userExperience', "");
      pref.setString('userSkills', "");
      pref.setString('userLocation', "");
      pref.setString("userQualifications", "");
      pref.setString('userLanguages', "");
    }

    pref.setString('userID', user.data.userId ?? "");
    pref.setString('userToken', user.data.userToken ?? "");
    pref.setString('userType', user.data.userType ?? "");
    pref.setString('userBio', user.data.userBio ?? "");
    pref.setBool('userIsLogged', true);
    pref.setString("userLogStep", "full");

    if (pref.get("loginType") == null) {
      pref.setString("loginType", "normal");
    }

    if (pref.getString("loginType") == "normal") {
      pref.setString("userMobile", user.data.userMobile);
      pref.setString('userName', user.data.userName ?? "");
      pref.setString('userPhoto', user.data.userPhoto ?? "");
      pref.setString('userEmail', user.data.userEmail ?? "");
    } else {
      pref.setString("userMobile", user.data.userMobile);
      pref.setString(
          'userName',
          user.data.userName != ""
              ? user.data.userName
              : pref.getString("userName"));
      pref.setString(
          'userPhoto',
          user.data.userPhoto != ""
              ? user.data.userPhoto
              : pref.getString("userPhoto"));
      pref.setString(
          'userEmail',
          user.data.userEmail != ""
              ? user.data.userEmail
              : pref.getString("userEmail"));
    }
  }

  static setGoogleSignInSession(credential) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var user = await FirebaseAuth.instance.signInWithCredential(credential);

    pref.setBool("userIsLogged", true);
    pref.setString("userLogStep", "half");
    pref.setString("userEmail", user.user.email ?? "");
    pref.setString(
        "userPhoto", user.user.photoURL ?? "$base_url/$application_logo");
    pref.setString("userName", user.user.displayName ?? "");
    pref.setString("loginType", "Google");
    pref.setString("userMobile", user.user.phoneNumber ?? "");
  }

  static unsetUserSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    UserApi().updateUser(pref.getString("userID"));
    pref.remove("userID");
    pref.remove("userName");
    pref.remove("userEmail");
    pref.remove("userPhoto");
    pref.remove("userBio");
    pref.remove("userMobile");
    pref.remove("userIsLogged");
    pref.remove("userLogStep");

    print('unsetting data');

    print(pref.getString("loginType"));
    if (pref.getString("loginType") == "Google") {
      await GoogleSignIn().signOut();
    }

    if (pref.getString("userType") == "1" ||
        pref.getString("userType") == "0") {
      pref.remove("userExperience");
      pref.remove("userQualifications");
      pref.remove("userSkills");
      pref.remove("userLocation");
      pref.remove("userJobLocation");
      pref.remove("userLanguages");
    } else if (pref.getString("userType") == "2") {
      pref.remove("userOrganization");
      pref.remove("userOrganizationType");
    }

    pref.remove("userType");
    pref.remove("loginType");
  }

  static Future<String> fetchUser(key) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getString(key);
  }
}
