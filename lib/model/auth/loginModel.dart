// To parse this JSON data, do
//
//     final loginApiModel = loginApiModelFromJson(jsonString);

import 'dart:convert';

LoginApiModel loginApiModelFromJson(String str) => LoginApiModel.fromJson(json.decode(str));

String loginApiModelToJson(LoginApiModel data) => json.encode(data.toJson());

class LoginApiModel {
  LoginApiModel({
    this.status,
    this.message,
  });

  bool status;
  String message;

  factory LoginApiModel.fromJson(Map<String, dynamic> json) => LoginApiModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
