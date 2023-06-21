// To parse this JSON data, do
//
//     final rakshModel = rakshModelFromJson(jsonString);

import 'dart:convert';

RakshModel rakshModelFromJson(String str) =>
    RakshModel.fromJson(json.decode(str));

String rakshModelToJson(RakshModel data) => json.encode(data.toJson());

class RakshModel {
  String id;
  String mobileNumber;
  bool isLogged;
  int generatedOtp;
  String token;
  String userType;
  LastLogin lastLogin;

  RakshModel({
    this.id,
    this.mobileNumber,
    this.isLogged,
    this.generatedOtp,
    this.token,
    this.userType,
    this.lastLogin,
  });

  factory RakshModel.fromJson(Map<String, dynamic> json) => RakshModel(
        id: json["id"],
        mobileNumber: json["mobile_number"],
        isLogged: json["isLogged"],
        generatedOtp: json["generatedOTP"],
        token: json["token"],
        userType: json["userType"],
        lastLogin: json["lastLogin"] == null
            ? null
            : LastLogin.fromJson(json["lastLogin"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "mobile_number": mobileNumber,
        "isLogged": isLogged,
        "generatedOTP": generatedOtp,
        "token": token,
        "userType": userType,
        "lastLogin": lastLogin.toJson(),
      };
}

class LastLogin {
  DateTime date;
  int timezoneType;
  String timezone;

  LastLogin({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  factory LastLogin.fromJson(Map<String, dynamic> json) => LastLogin(
        date: DateTime.parse(json["date"]) ?? null,
        timezoneType: json["timezone_type"] ?? null,
        timezone: json["timezone"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "timezone_type": timezoneType,
        "timezone": timezone,
      };
}
