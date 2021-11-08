import 'package:flutter/cupertino.dart';

class UserDataNotifier extends ChangeNotifier {

  String _userName = "";
  String _userBio = "";
  String _userType = "";
  String _userPhoto = "";
  String _userExperience = "";
  String _userQualification = "";
  String _userSkills = "";
  String _userLocation = "";
  String _userJobLocation = "";
  String _userLanguages = "";
  String _userEmail = "";
  String _userID = "";

  String get userName => _userName;
  String get userBio => _userBio;
  String get userType => _userType;
  String get userPhoto => _userPhoto;
  String get userExperience => _userExperience;
  String get userQualification => _userQualification;
  String get userSkills => _userSkills;
  String get userLocation => _userLocation;
  String get userJobLocation => _userJobLocation;
  String get userLanguages => _userLanguages;
  String get userEmail => _userEmail;
  String get userID => _userID;

  setUserEmployee(userData) {
      _userName = userData['userName'];
      _userBio = userData['userBio'];
      _userType = userData['userType'];
      _userPhoto = userData['userPhoto'];
      _userExperience = userData['userExperience'];
      _userQualification = userData['userQualification'];
      _userSkills = userData['userSkills'];
      _userLocation = userData['userLocation'];
      _userJobLocation = userData['userJobLocation'];
      _userLanguages = userData['userLanguages'];
      _userEmail = userData['userEmail'];
      _userID = userData['userID'];
  }

}